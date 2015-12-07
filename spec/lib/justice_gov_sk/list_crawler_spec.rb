require 'rails_helper'

RSpec.shared_examples_for JusticeGovSk::ListCrawler do
  describe '.perform_later' do
    it 'crawls list specified by url' do
      VCR.use_cassette(vcr_cassette_name) do
        crawler = class_double(resource_crawler).as_stubbed_const

        expect(crawler).to receive(:perform_later).with(links[0])
        expect(crawler).to receive(:perform_later).with(links[1])
        expect(crawler).to receive(:perform_later).exactly(198).times

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
      expect {
        VCR.use_cassette(vcr_cassette_name) do
          described_class.new.perform(url)
        end
      }.to satisfy(
        have_enqueued_job(resource_crawler).with(links[0]).on_queue(resource_queue),
        have_enqueued_job(resource_crawler).with(links[1]).on_queue(resource_queue),
        have_enqueued_job(resource_crawler).on_queue(resource_queue).exactly(200).times
      )
    end
  end
end
