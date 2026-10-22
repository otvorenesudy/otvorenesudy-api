# frozen_string_literal: true

require 'rails_helper'

# The daily import of civil hearings (config/schedule.rb): obcan.justice.sk's civil hearings a page of a thousand at a
# time, each page fetched by ObcanJusticeSk::ImportCivilHearingsJob and each hearing by
# ObcanJusticeSk::ImportCivilHearingJob.
RSpec.describe ObcanJusticeSk::CivilHearings do
  let(:base_url) { 'https://obcan.justice.sk/pilot/api/ress-isu-service/v1/obcianPojednavania' }

  def list(found, hearings = [])
    { numFound: found, page: 0, size: 1, updateDate: '2024-03-01', obcianPojednavaniaList: hearings }
  end

  describe '.import' do
    it 'enqueues a page of a thousand hearings for each thousand obcan.justice.sk has' do
      stub_json("#{base_url}?size=1&page=0", list(1001))

      described_class.import

      expect(ObcanJusticeSk::ImportCivilHearingsJob).to have_been_enqueued.exactly(2).times
      expect(ObcanJusticeSk::ImportCivilHearingsJob).to have_been_enqueued.with("#{base_url}?size=1000&page=2")
    end

    it 'stops at a list that is not what the importer expects' do
      stub_json("#{base_url}?size=1&page=0", { numFound: 1001 })

      expect { described_class.import }.to raise_error(JSON::Schema::ValidationError)
    end
  end

  describe 'a page of hearings' do
    let(:page_url) { "#{base_url}?size=1000&page=1" }

    it 'enqueues the import of each hearing on it' do
      stub_json(page_url, list(1, [{ guid: 'f5c7b3ce-e9d6-44ed-adca-66b57190e542' }]))

      ObcanJusticeSk::ImportCivilHearingsJob.perform_now(page_url)

      expect(ObcanJusticeSk::ImportCivilHearingJob)
        .to have_been_enqueued.with('f5c7b3ce-e9d6-44ed-adca-66b57190e542')
    end

    it 'stops at a page that is not what the importer expects' do
      stub_json(page_url, { obcianPojednavaniaList: 'none' })

      expect { ObcanJusticeSk::ImportCivilHearingsJob.perform_now(page_url) }
        .to raise_error(JSON::Schema::ValidationError)
    end
  end

  describe 'a hearing' do
    let(:guid) { 'f5c7b3ce-e9d6-44ed-adca-66b57190e542' }

    it 'is stored with its parties anonymized, and its reconciliation enqueued' do
      stub_json("#{base_url}/#{guid}", source_fixture('civil_hearing'))

      ObcanJusticeSk::ImportCivilHearingJob.perform_now(guid)

      hearing = ObcanJusticeSk::CivilHearing.sole

      expect(hearing).to have_attributes(guid:, uri: "#{base_url}/#{guid}")
      expect(hearing.data['odporcovia'].pluck('meno')).to all(match(/\A[A-Z]\. [A-Z]\.\z/))
      expect(ReconcileHearingJob).to have_been_enqueued.with(hearing)
    end

    it 'stops at a hearing that is not what the importer expects' do
      stub_json("#{base_url}/#{guid}", source_fixture('civil_hearing').merge('usek' => 'X'))

      expect { ObcanJusticeSk::ImportCivilHearingJob.perform_now(guid) }.to raise_error(JSON::Schema::ValidationError)
    end
  end
end
