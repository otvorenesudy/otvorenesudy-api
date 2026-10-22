# frozen_string_literal: true

require 'rails_helper'
require 'zip'

# InfoSud, obcan.justice.sk's former open data: zipped JSON dumps of courts, judges, hearings and decrees, downloaded
# into tmp/downloads/info_sud, unpacked, and each record stored as published. Maintainers run it with rake info_sud:*.
RSpec.describe InfoSud do
  let(:opendata_url) { 'https://obcan.justice.sk/opendata' }

  def zip(*contents)
    Zip::OutputStream.write_buffer do |archive|
      contents.each_with_index do |content, index|
        archive.put_next_entry("#{index}.json")
        archive.write(content)
      end
    end.string
  end

  def stub_dump(url, filename, *fixtures)
    stub_request(:get, url).to_return(
      body: zip(*fixtures.map { file_fixture("info_sud/#{it}.json").read }),
      headers: { 'Content-Type' => 'application/zip', 'Content-Disposition' => %(attachment; filename="#{filename}") }
    )
  end

  def decree_dump_url(name)
    "#{opendata_url}?p_p_id=isuopendata_WAR_isufront&p_p_resource_id=isu_sr_#{name}_json.zip"
  end

  describe '.import_courts' do
    it 'stores the courts of the dump, and enqueues their reconciliation' do
      stub_dump(described_class::COURTS_URL, 'reg-sudy_json.zip', 'updated_courts')

      described_class.import_courts

      expect(InfoSud::Court.count).to eq(64)
      expect(InfoSud::Court.find_by!(guid: 'sud_100').data['typ_sudu']).to eq('Najvyšší súd SR')
      expect(ReconcileCourtJob).to have_been_enqueued.exactly(64).times
    end
  end

  describe '.import_judges' do
    it 'stores the judges of the dump' do
      stub_dump(described_class::JUDGES_URL, 'reg-sudcovia_json.zip', 'judges')

      described_class.import_judges

      expect(InfoSud::Judge.order(:guid).pluck(:guid)).to eq(%w[sudca_1507 sudca_1508])
    end
  end

  describe '.import_hearings' do
    it 'stores the hearings of the dump, and updates them from a later one' do
      stub_dump(described_class::HEARINGS_URL, 'isu_sp_json.zip', 'hearings')
      described_class.import_hearings
      stub_dump(described_class::HEARINGS_URL, 'isu_sp_json.zip', 'updated_hearings')

      expect { described_class.import_hearings }.not_to(change(InfoSud::Hearing, :count))
      expect(InfoSud::Hearing.pluck(:data)).to match_array(
        JSON.parse(file_fixture('info_sud/updated_hearings.json').read)['data'].map { it.except('index_timestamp') }
      )
    end
  end

  describe '.import_decrees' do
    let(:dumps) { %w[2015 2016 2017 2018 2019-1 2019-2 2019-3 2019-4] }

    before do
      links = dumps.map { %(<a href="#{decree_dump_url(it)}">#{it}</a>) }.join

      stub_request(:get, opendata_url).to_return(body: "<html><body><a href='/'>Home</a>#{links}</body></html>")
      dumps.each { stub_dump(decree_dump_url(it), "isu_sr_#{it}_json.zip", 'decrees') }
    end

    it 'stores the decrees of the six latest dumps the open data page links to' do
      described_class.import_decrees

      expect(InfoSud::Decree.count).to eq(2)
      expect(a_request(:get, decree_dump_url('2016'))).not_to have_been_made
      expect(a_request(:get, decree_dump_url('2019-4'))).to have_been_made
    end

    it 'reads every dump when asked for all decrees' do
      ENV['INFO_SUD_IMPORT_ALL_DECREES'] = '1'

      described_class.import_decrees

      expect(a_request(:get, decree_dump_url('2015'))).to have_been_made
    ensure
      ENV.delete('INFO_SUD_IMPORT_ALL_DECREES')
    end
  end
end
