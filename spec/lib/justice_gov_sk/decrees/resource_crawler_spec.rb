require 'rails_helper'

RSpec.describe JusticeGovSk::Decrees::ResourceCrawler do
  let(:uri) { 'https://obcan.justice.sk/infosud/-/infosud/i-detail/rozhodnutie/d83847dc-be23-4b7c-aa89-064848f4364b%3Ae501691e-2a79-4feb-aed7-1b689ef35cfd' }
  let(:downloader) { double(:downloader) }
  let(:parser) { double(:parser) }
  let(:repository) { double(:repository) }

  before :each do
    stub_const('JusticeGovSk::Downloader', downloader)
    stub_const('JusticeGovSk::Decrees::ResourceParser', parser)
    stub_const('JusticeGovSk::Decree', repository)
  end

  describe '.perform_later' do
    it 'crawls decree' do
      allow(downloader).to receive(:download).with(uri) { 'html' }
      allow(parser).to receive(:parse).with('html') { { attribute: 1 } }
      expect(repository).to receive(:import_from).with(uri: uri, attribute: 1)

      JusticeGovSk::Decrees::ResourceCrawler.perform_later(uri)
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
          JusticeGovSk::Decrees::ResourceCrawler.perform_later(uri)
        }.to have_enqueued_job(JusticeGovSk::Decrees::ResourceCrawler).with(uri).on_queue('decree')
      end
    end
  end
end
