# frozen_string_literal: true

require 'rails_helper'

# The import of decrees (config/schedule.rb): obcan.justice.sk's decrees indexed since a day on weekdays, all of them on
# Saturdays, a page of a thousand at a time; each page then fetched by ObcanJusticeSk::ImportDecreesJob and each
# decree by ObcanJusticeSk::ImportDecreeJob.
RSpec.describe ObcanJusticeSk::Decrees do
  let(:base_url) { 'https://obcan.justice.sk/pilot/api/ress-isu-service/v1/rozhodnutie' }

  def list(found, decrees = [])
    { numFound: found, page: 0, size: 1, updateDate: '2024-03-01', rozhodnutieList: decrees }
  end

  describe '.import' do
    it 'enqueues a page of a thousand decrees for each thousand obcan.justice.sk has' do
      stub_json("#{base_url}?size=1&page=0", list(2500))

      described_class.import

      expect(ObcanJusticeSk::ImportDecreesJob).to have_been_enqueued.exactly(3).times
      (1..3).each do |page|
        expect(ObcanJusticeSk::ImportDecreesJob).to have_been_enqueued.with("#{base_url}?size=1000&page=#{page}")
      end
    end

    # obcan.justice.sk numbers its pages from 1: asked for page 0, it says it answers page -1 and gives the first page.
    it 'imports every decree once, from the first page to the last' do
      stub_json("#{base_url}?size=1&page=0", list(2001))
      { 0 => %w[a b], 1 => %w[a b], 2 => %w[c], 3 => %w[d], 4 => [] }.each do |page, guids|
        stub_json("#{base_url}?size=1000&page=#{page}", list(2001, guids.map { { guid: it } }))
      end

      perform_enqueued_jobs(only: ObcanJusticeSk::ImportDecreesJob) { described_class.import }

      expect(ObcanJusticeSk::ImportDecreeJob).to have_been_enqueued.exactly(4).times
      %w[a b c d].each { expect(ObcanJusticeSk::ImportDecreeJob).to have_been_enqueued.with(it).once }
    end

    it 'asks for the decrees indexed since a day' do
      stub_json("#{base_url}?size=1&page=0&indexDatumOd=2024-03-01", list(10))

      described_class.import(since: Time.zone.local(2024, 3, 1, 4))

      expect(ObcanJusticeSk::ImportDecreesJob)
        .to have_been_enqueued.with("#{base_url}?size=1000&page=1&indexDatumOd=2024-03-01")
    end

    it 'stops at a list that is not what the importer expects' do
      stub_json("#{base_url}?size=1&page=0", { numFound: 'many' })

      expect { described_class.import }.to raise_error(JSON::Schema::ValidationError)
    end
  end

  describe 'a page of decrees' do
    let(:page_url) { "#{base_url}?size=1000&page=1" }

    it 'enqueues the import of each decree on it' do
      stub_json(page_url, list(2, [{ guid: 'a' }, { guid: 'b' }]))

      ObcanJusticeSk::ImportDecreesJob.perform_now(page_url)

      expect(ObcanJusticeSk::ImportDecreeJob).to have_been_enqueued.exactly(2).times
      expect(ObcanJusticeSk::ImportDecreeJob).to have_been_enqueued.with('b')
    end

    it 'stops at a page that is not what the importer expects' do
      stub_json(page_url, { rozhodnutieList: 'none' })

      expect { ObcanJusticeSk::ImportDecreesJob.perform_now(page_url) }.to raise_error(JSON::Schema::ValidationError)
    end
  end

  describe 'a decree' do
    let(:guid) { '819aef78-bdd4-4855-b8ed-d936446d41a2:3855d4dc-1209-4ddf-8a63-34cb3349cede' }

    it 'is stored as published, and its reconciliation enqueued' do
      stub_json("#{base_url}/#{guid}", source_fixture('decree'))

      ObcanJusticeSk::ImportDecreeJob.perform_now(guid)

      expect(ObcanJusticeSk::Decree.sole).to have_attributes(guid:, uri: "#{base_url}/#{guid}")
      expect(ReconcileDecreeJob).to have_been_enqueued.with(ObcanJusticeSk::Decree.sole)
    end

    it 'stops at a decree that is not what the importer expects' do
      stub_json("#{base_url}/#{guid}", source_fixture('decree').except('guid'))

      expect { ObcanJusticeSk::ImportDecreeJob.perform_now(guid) }.to raise_error(JSON::Schema::ValidationError)
    end
  end
end
