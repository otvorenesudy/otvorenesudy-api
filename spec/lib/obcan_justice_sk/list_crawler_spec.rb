require 'rails_helper'

RSpec.shared_examples_for ObcanJusticeSk::ListCrawler do
  describe '.perform_later' do
    it 'crawls list specified by url' do
      VCR.use_cassette(vcr_cassette_name) do
        crawler = class_double(resource_crawler).as_stubbed_const

        links.each do |link|
          expect(crawler).to receive(:perform_later).with(link)
        end

        expect(crawler).to receive(:perform_later).exactly(items - links.size).times

        described_class.perform_later(url)
      end
    end

    context 'with async adapter' do
      before :each do
        ActiveJob::Base.queue_adapter = :test
      end

      after :each do
        ActiveJob::Base.queue_adapter = :inline
      end

      it 'enqueues job to queue with proper name' do
        expect {
          described_class.perform_later(url)
        }.to have_enqueued_job(described_class).with(url).on_queue(queue)
      end
    end
  end

  describe '#perform' do
    before :each do
      ActiveJob::Base.queue_adapter = :test
    end

    after :each do
      ActiveJob::Base.queue_adapter = :inline
    end

    it 'enqueues jobs for resources' do
      matchers = links.map { |link| have_enqueued_job(resource_crawler).with(link).on_queue(resource_queue) }

      matchers << have_enqueued_job(resource_crawler).on_queue(resource_queue).exactly(items).times

      expect {
        VCR.use_cassette(vcr_cassette_name) do
          described_class.new.perform(url)
        end
      }.to satisfy(*matchers)
    end
  end
end
