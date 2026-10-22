# frozen_string_literal: true

require 'rails_helper'

# The daily import of judges (config/schedule.rb): the list of judges from obcan.justice.sk, each judge then fetched by
# ObcanJusticeSk::ImportJudgeJob.
RSpec.describe ObcanJusticeSk::Judges do
  let(:base_url) { 'https://obcan.justice.sk/pilot/api/ress-isu-service/v1/sudca' }
  let(:guids) { Array.new(2000) { |n| "sudca_#{n + 1}" } }

  def list(judges)
    { numFound: judges.size, page: 0, size: 10_000, updateDate: '2024-03-01', sudcaList: judges }
  end

  describe '.import' do
    it 'enqueues the import of every judge of the list' do
      stub_json("#{base_url}?size=10000", list(guids.map { { registreGuid: it } }))

      described_class.import

      expect(ObcanJusticeSk::ImportJudgeJob).to have_been_enqueued.exactly(2000).times
      expect(ObcanJusticeSk::ImportJudgeJob).to have_been_enqueued.with('sudca_2000')
    end

    it 'stops at a list that is not what the importer expects' do
      stub_json("#{base_url}?size=10000", list([{ registreGuid: 'sudca_1' }]))

      expect { described_class.import }.to raise_error(JSON::Schema::ValidationError)
      expect(ObcanJusticeSk::ImportJudgeJob).not_to have_been_enqueued
    end
  end
end
