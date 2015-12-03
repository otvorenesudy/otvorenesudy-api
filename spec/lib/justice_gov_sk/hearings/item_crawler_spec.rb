require 'rails_helper'

RSpec.describe JusticeGovSk::Hearings::ItemCrawler do
  let(:uri) { 'https://obcan.justice.sk/infosud/-/infosud/i-detail/pojednavanie/5b341263-c6bc-4935-ab25-4fd56b288829' }
  let(:downloader) { double(:downloader) }
  let(:parser) { double(:parser) }
  let(:repository) { double(:repository) }

  before :each do
    stub_const('JusticeGovSk::Downloader', downloader)
    stub_const('JusticeGovSk::Hearings::ItemParser', parser)
    stub_const('JusticeGovSk::Hearing', repository)
  end

  describe '.perform_later' do
    it 'crawls hearing' do
      allow(downloader).to receive(:download).with(uri) { 'html' }
      allow(parser).to receive(:parse).with('html') { { attribute: 1 } }
      expect(repository).to receive(:import_from).with(uri: uri, attribute: 1)

      JusticeGovSk::Hearings::ItemCrawler.perform_later(uri)
    end

    context 'with async adapter' do
      before :each do
        ActiveJob::Base.queue_adapter = :test
      end

      after :each do
        ActiveJob::Base.queue_adapter = :inline
      end

      it 'enques job to queue with proper name' do
        expect {
          JusticeGovSk::Hearings::ItemCrawler.perform_later(uri)
        }.to have_enqueued_job(JusticeGovSk::Hearings::ItemCrawler).with(uri).on_queue('hearing')
      end
    end
  end
end
