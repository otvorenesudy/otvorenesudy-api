# frozen_string_literal: true

require 'rails_helper'

# InfoSud's dumps become Open Courts records as obcan.justice.sk's records do: the import stores each record, which
# enqueues its reconciliation, and the job writes it into the Open Courts database and asks otvorenesudy to reindex
# it. InfoSud is faked: each dump holds one record of the fixtures in spec/fixtures/info_sud.
RSpec.describe InfoSud do
  let(:initials) { /\A[A-Z]\. [A-Z]\.\z/ }

  before { create_lookups }

  def dump_of(fixture, guid)
    { data: [JSON.parse(file_fixture("info_sud/#{fixture}.json").read)['data'].find { it['guid'] == guid }] }.to_json
  end

  def import(dump, url:, filename:, &)
    stub_info_sud_dump(url, filename, dump)

    perform_enqueued_jobs(&)
  end

  describe '.import_courts' do
    it 'writes a court into Open Courts, with its type, seat and registry, and asks otvorenesudy to reindex it' do
      import(dump_of('updated_courts', 'sud_100'), url: InfoSud::COURTS_URL, filename: 'reg-sudy_json.zip') do
        described_class.import_courts
      end

      court = Court.sole

      expect(court).to have_attributes(name: 'Najvyšší súd Slovenskej republiky', acronym: 'NSSR',
                                       source_class: 'InfoSud::Court', source_class_id: InfoSud::Court.sole.id)
      expect([court.type.value, court.municipality.name, court.municipality.zipcode, court.registry_center.email])
        .to eq(['Najvyšší', 'Bratislava', '814 90', 'podatelna@nsud.sk'])
      expect(Sidekiq::Queues['probe'].pluck('args')).to eq([['Court', court.id]])
    end
  end

  describe '.import_judges' do
    it 'writes a judge into Open Courts, employed at their court and at the court they are assigned to' do
      create(:court, name: 'Okresný súd Levice')
      create(:court, name: 'Krajský súd Nitra')

      import(dump_of('judges', 'sudca_1508'), url: InfoSud::JUDGES_URL, filename: 'reg-sudcovia_json.zip') do
        described_class.import_judges
      end

      judge = Judge.sole

      expect(judge).to have_attributes(name: 'JUDr. Martina Balegová', source_class: 'InfoSud::Judge',
                                       source_class_id: InfoSud::Judge.sole.id)
      expect(judge.employments.order(:id).map { [it.court.name, it.position.value, it.active] })
        .to eq([['Okresný súd Levice', 'sudca', true], ['Krajský súd Nitra', 'sudca', true]])
    end
  end

  describe '.import_hearings' do
    it 'writes a hearing into Open Courts, with its court, judge and type, and its defendants by initials' do
      court = create(:court, name: 'Mestský súd Košice')
      judge = create(:judge, name: 'JUDr. Margaréta Hlaváčková')

      import(dump_of('hearings', '94fed4fd-af4a-42c3-8c21-788358207927'),
             url: InfoSud::HEARINGS_URL, filename: 'isu_sp_json.zip') { described_class.import_hearings }

      hearing = Hearing.sole

      expect(hearing).to have_attributes(
        court:, judges: [judge], file_number: '7115010154', case_number: '3T/9/2015',
        date: Time.zone.parse('2015-12-07 13:30'), source_class: 'InfoSud::Hearing', source_class_id: InfoSud::Hearing.sole.id
      )
      expect(hearing.type.value).to eq('Trestné')
      expect(hearing.defendants.pluck(:name)).to all(match(initials))
    end
  end

  describe '.import_decrees' do
    it 'writes a decree into Open Courts, with its court, form, judge and the text the dump holds' do
      court = create(:court, name: 'Okresný súd Rožňava')
      judge = create(:judge, name: 'Mgr. Milan Krak')
      create(:decree_form, value: 'Uznesenie', code: 'N')
      url = 'https://obcan.justice.sk/opendata?p_p_id=isuopendata_WAR_isufront&p_p_resource_id=isu_sr_2015_json.zip'
      stub_request(:get, 'https://obcan.justice.sk/opendata').to_return(body: %(<a href="#{url}">2015</a>))

      import(dump_of('decrees', '8db35214-01e6-4ed9-bf10-02f41884dec2:a0ab01fc-955b-4c8b-a3f0-975fe178edeb'),
             url:, filename: 'isu_sr_2015_json.zip') { described_class.import_decrees }

      decree = Decree.sole

      expect(decree).to have_attributes(court:, judges: [judge], ecli: 'ECLI:SK:OSRV:2015:7813210471.2',
                                        date: Date.new(2015, 4, 13), source_class: 'InfoSud::Decree',
                                        source_class_id: InfoSud::Decree.sole.id)
      expect([decree.form.value, decree.pages.pluck(:text)]).to eq(['Uznesenie', ['Fulltext #1']])
    end
  end
end
