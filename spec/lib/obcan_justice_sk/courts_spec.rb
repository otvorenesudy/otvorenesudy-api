# frozen_string_literal: true

require 'rails_helper'

# The daily import of courts (config/schedule.rb): the list of courts from obcan.justice.sk, then each court, stored as
# published and reconciled into Open Courts.
RSpec.describe ObcanJusticeSk::Courts do
  let(:base_url) { 'https://obcan.justice.sk/pilot/api/ress-isu-service/v1/sud' }
  let(:guids) { Array.new(50) { |n| "sud_#{100 + n}" } }

  before do
    list = { numFound: 50, page: 0, size: 1000, updateDate: '2024-03-01', sudList: guids.map { { registreGuid: it } } }

    stub_json("#{base_url}?size=1000", list)
    stub_request(:get, %r{\A#{base_url}/sud_\d+\z}).to_return do |request|
      { body: court(request.uri.path.split('/').last).to_json, headers: { 'Content-Type' => 'application/json' } }
    end
  end

  def court(guid)
    source_fixture('court').merge('registreGuid' => guid)
  end

  describe '.import' do
    it 'stores every court of the list as published, and reconciles each' do
      described_class.import

      expect(ObcanJusticeSk::Court.order(:guid).pluck(:guid, :uri)).to eq(guids.map { [it, "#{base_url}/#{it}"] })
      expect(ObcanJusticeSk::Court.find_by!(guid: 'sud_149').data).to eq(court('sud_149'))
      expect(ReconcileCourtJob).to have_been_enqueued.exactly(50).times
    end

    it 'stores nothing new for a court published as it was' do
      described_class.import

      expect { described_class.import }.not_to(change { ObcanJusticeSk::Court.maximum(:updated_at) })
    end

    it 'stops at a list that is not what the importer expects' do
      stub_json("#{base_url}?size=1000", { numFound: 50, sudList: [] })

      expect { described_class.import }.to raise_error(JSON::Schema::ValidationError)
      expect(ObcanJusticeSk::Court.count).to eq(0)
    end

    it 'stops at a court that is not what the importer expects' do
      stub_json(%r{\A#{base_url}/sud_\d+\z}, source_fixture('court').except('nazov'))

      expect { described_class.import }.to raise_error(JSON::Schema::ValidationError)
    end
  end
end
