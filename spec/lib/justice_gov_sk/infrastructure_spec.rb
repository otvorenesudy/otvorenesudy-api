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
      VCR.use_cassette(vcr_cassette_name) do
        expect {
          described_class.crawl
        }.to satisfy(
          have_enqueued_job(list_crawler).on_queue(queue).exactly(pages).times,
          have_enqueued_job(list_crawler).on_queue(queue).with(page: 1),
          have_enqueued_job(list_crawler).on_queue(queue).with(page: 2),
          have_enqueued_job(list_crawler).on_queue(queue).with(page: pages)
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
