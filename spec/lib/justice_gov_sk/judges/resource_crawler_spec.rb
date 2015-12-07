require 'rails_helper'

RSpec.describe JusticeGovSk::Judges::ResourceCrawler do
  let(:uri) { 'https://obcan.justice.sk/infosud/-/infosud/reg-detail/sudca/sudca_587' }
  let(:downloader) { class_double(JusticeGovSk::Downloader).as_stubbed_const }
  let(:parser) { class_double(JusticeGovSk::Judges::ResourceParser).as_stubbed_const }
  let(:repository) { class_double(JusticeGovSk::Judge).as_stubbed_const }

  describe '.perform_later' do
    it 'crawls hearing' do
      allow(downloader).to receive(:download).with(uri) { 'html' }
      allow(parser).to receive(:parse).with('html') { { attribute: 1 } }
      expect(repository).to receive(:import_from).with(uri: uri, attribute: 1)

      JusticeGovSk::Judges::ResourceCrawler.perform_later(uri)
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
          JusticeGovSk::Judges::ResourceCrawler.perform_later(uri)
        }.to have_enqueued_job(JusticeGovSk::Judges::ResourceCrawler).with(uri).on_queue('judge')
      end
    end
  end
end
