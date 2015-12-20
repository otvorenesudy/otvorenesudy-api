require 'rails_helper'

RSpec.shared_examples_for ObcanJusticeSk::ResourceCrawler do
  let(:downloader) { class_double(ObcanJusticeSk::Downloader).as_stubbed_const }

  describe '.perform_later' do
    it 'crawls resource' do
      allow(downloader).to receive(:download).with(uri) { 'html' }
      allow(parser).to receive(:parse).with('html') { { attribute: 1 } }
      expect(repository).to receive(:import_from).with(uri: uri, html: 'html', attribute: 1)

      described_class.perform_later(uri)
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
          described_class.perform_later(uri)
        }.to have_enqueued_job(described_class).with(uri).on_queue(queue)
      end
    end
  end
end
