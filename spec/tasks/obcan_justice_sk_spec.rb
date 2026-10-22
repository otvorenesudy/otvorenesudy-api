# frozen_string_literal: true

require 'rails_helper'
require 'rake'

# Run by the maintainers when obcan.justice.sk withdraws decrees: it deletes what the source no longer lists.
RSpec.describe 'obcan_justice_sk tasks', type: :task do
  let(:decrees_url) { 'https://obcan.justice.sk/pilot/api/ress-isu-service/v1/rozhodnutie' }

  before do
    Rails.application.load_tasks unless Rake::Task.task_defined?('obcan_justice_sk:consolidate_decrees')
  end

  def run(task)
    Rake::Task[task].tap(&:reenable).invoke
  end

  def stored(guid)
    create(:obcan_justice_sk_decree, guid:)
  end

  def reconciled(record)
    create(:decree, source_class: 'ObcanJusticeSk::Decree', source_class_id: record.id)
  end

  describe 'obcan_justice_sk:consolidate_decrees' do
    it 'deletes the decrees the source no longer lists, the ones never reconciled, and their Open Courts decrees' do
      listed, _unreconciled, withdrawn = %w[listed unreconciled withdrawn].map { |guid| stored(guid) }
      kept, deleted = [listed, withdrawn].map { reconciled(it) }

      stub_json("#{decrees_url}?size=1&page=1", { numFound: 2 })
      stub_json("#{decrees_url}?size=1000&page=1", { rozhodnutieList: [{ guid: 'listed' }, { guid: 'unreconciled' }] })

      expect { run('obcan_justice_sk:consolidate_decrees') }.to output(/Deleted \[1\] orphaned decrees/).to_stdout

      expect(ObcanJusticeSk::Decree.all).to eq([listed])
      expect(Decree.where(id: [kept.id, deleted.id])).to eq([kept])
    end
  end
end
