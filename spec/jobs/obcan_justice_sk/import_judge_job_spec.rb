# frozen_string_literal: true

require 'rails_helper'

# Imports one judge by their id on obcan.justice.sk, as ObcanJusticeSk::Judges.import enqueues it.
RSpec.describe ObcanJusticeSk::ImportJudgeJob do
  let(:url) { 'https://obcan.justice.sk/pilot/api/ress-isu-service/v1/sudca/sudca_1' }

  it 'stores the judge as published, and enqueues their reconciliation' do
    stub_json(url, source_fixture('judge'))

    described_class.perform_now('sudca_1')

    expect(ObcanJusticeSk::Judge.sole).to have_attributes(guid: 'sudca_1', uri: url, data: source_fixture('judge'))
    expect(ReconcileJudgeJob).to have_been_enqueued.with(ObcanJusticeSk::Judge.sole)
  end

  it 'stops at a judge that is not what the importer expects' do
    stub_json(url, source_fixture('judge').except('meno'))

    expect { described_class.perform_now('sudca_1') }.to raise_error(JSON::Schema::ValidationError)
    expect(ObcanJusticeSk::Judge.count).to eq(0)
  end
end
