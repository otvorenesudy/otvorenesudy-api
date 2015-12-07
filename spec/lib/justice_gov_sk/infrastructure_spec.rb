require 'rails_helper'

RSpec.shared_examples_for JusticeGovSk::Infrastructure do
  describe '.crawl' do
    before :each do
      ActiveJob::Base.queue_adapter = :test
    end

    after :each do
      ActiveJob::Base.queue_adapter = :inline
    end

    it 'enqueues crawlers for all lists' do
      params = [
        described_class.uri.build_for(page: 1),
        described_class.uri.build_for(page: 2),
        described_class.uri.build_for(page: 3),
        described_class.uri.build_for(page: pages)
      ]

      VCR.use_cassette(vcr_cassette_name) do
        expect {
          described_class.crawl
        }.to satisfy(
          have_enqueued_job(list_crawler).on_queue(queue).exactly(pages).times,
          have_enqueued_job(list_crawler).on_queue(queue).with(params[0]),
          have_enqueued_job(list_crawler).on_queue(queue).with(params[1]),
          have_enqueued_job(list_crawler).on_queue(queue).with(params[2]),
          have_enqueued_job(list_crawler).on_queue(queue).with(params[3])
        )
      end
    end
  end

  describe '.pages' do
    it 'gets number of pages in the list' do
      VCR.use_cassette(vcr_cassette_name) do
        expect(described_class.pages).to eql(pages)
      end
    end
  end
end
