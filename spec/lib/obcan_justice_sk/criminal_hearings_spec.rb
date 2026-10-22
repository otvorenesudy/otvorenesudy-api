# frozen_string_literal: true

require 'rails_helper'

# The daily import of criminal hearings (config/schedule.rb): api.justice.gov.sk's criminal hearings a thousand at a
# time, each batch fetched by ObcanJusticeSk::ImportCriminalHearingsJob and each hearing by
# ObcanJusticeSk::ImportCriminalHearingJob.
RSpec.describe ObcanJusticeSk::CriminalHearings do
  let(:base_url) { 'https://api.justice.gov.sk/pojednavanie/trestne' }
  let(:id) { 'CCDA6228-8F0F-4364-B60C-5BA527607C8B_711769' }

  def list_url(skip, take: 1000)
    "#{base_url}?take=#{take}&skip=#{skip}"
  end

  describe '.import' do
    it 'enqueues a batch of a thousand hearings for each thousand there are, from the first' do
      stub_json("#{base_url}?take=1&skip=0", { filteredCount: 1500, data: [], take: 1 })

      described_class.import

      expect(ObcanJusticeSk::ImportCriminalHearingsJob).to have_been_enqueued.exactly(2).times
      [0, 1000].each do |skip|
        expect(ObcanJusticeSk::ImportCriminalHearingsJob).to have_been_enqueued.with(list_url(skip))
      end
    end

    # api.justice.gov.sk skips that many hearings, from 0, and reports how many there are in all as filteredCount.
    it 'imports every hearing once, from the first batch to the last' do
      stub_json("#{base_url}?take=1&skip=0", { filteredCount: 2001, data: [{ id: 'a' }], take: 1 })
      { 0 => %w[a b], 1000 => %w[c], 2000 => %w[d], 3000 => [] }.each do |skip, ids|
        stub_json(list_url(skip), { filteredCount: 2001, data: ids.map { { id: it } }, take: 1000 })
      end

      perform_enqueued_jobs(only: ObcanJusticeSk::ImportCriminalHearingsJob) { described_class.import }

      expect(ObcanJusticeSk::ImportCriminalHearingJob).to have_been_enqueued.exactly(4).times
      %w[a b c d].each { expect(ObcanJusticeSk::ImportCriminalHearingJob).to have_been_enqueued.with(it).once }
    end

    it 'stops at a list that is not what the importer expects' do
      stub_json("#{base_url}?take=1&skip=0", { data: [] })

      expect { described_class.import }.to raise_error(JSON::Schema::ValidationError)
    end
  end

  describe 'a batch of hearings' do
    let(:batch_url) { "#{base_url}?take=1000&skip=1000" }

    it 'enqueues the import of each hearing in it' do
      stub_json(batch_url, { filteredCount: 1, data: [{ id: }], take: 1000 })

      ObcanJusticeSk::ImportCriminalHearingsJob.perform_now(batch_url)

      expect(ObcanJusticeSk::ImportCriminalHearingJob).to have_been_enqueued.with(id)
    end

    it 'stops at a batch that is not what the importer expects' do
      stub_json(batch_url, { filteredCount: 1, data: 'none', take: 1000 })

      expect { ObcanJusticeSk::ImportCriminalHearingsJob.perform_now(batch_url) }
        .to raise_error(JSON::Schema::ValidationError)
    end
  end

  describe 'a hearing' do
    it 'is stored with its defendants anonymized, and its reconciliation enqueued' do
      stub_json("#{base_url}/#{id}", source_fixture('criminal_hearing'))

      ObcanJusticeSk::ImportCriminalHearingJob.perform_now(id)

      hearing = ObcanJusticeSk::CriminalHearing.sole

      expect(hearing).to have_attributes(guid: id, uri: "#{base_url}/#{id}")
      expect(hearing.data['obzalovani']).to all(match(/\A[A-Z]\. [A-Z]\.\z/))
      expect(ReconcileHearingJob).to have_been_enqueued.with(hearing)
    end

    it 'stops at a hearing that is not what the importer expects' do
      stub_json("#{base_url}/#{id}", source_fixture('criminal_hearing').merge('usek' => 'Civilný'))

      expect { ObcanJusticeSk::ImportCriminalHearingJob.perform_now(id) }.to raise_error(JSON::Schema::ValidationError)
    end
  end
end
