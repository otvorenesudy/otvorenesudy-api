require 'rails_helper'

RSpec.describe JusticeGovSk::Decrees do
  describe '.crawl' do
    before :each do
      ActiveJob::Base.queue_adapter = :test
    end

    after :each do
      ActiveJob::Base.queue_adapter = :inline
    end

    it 'enqueues crawlers for all lists' do
      VCR.use_cassette('justice_gov_sk/decree_list') do
        expect {
          JusticeGovSk::Decrees.crawl
        }.to satisfy(
          have_enqueued_job(JusticeGovSk::Decrees::ListCrawler).on_queue('decrees').exactly(8332).times,
          have_enqueued_job(JusticeGovSk::Decrees::ListCrawler).on_queue('decrees').with(page: 1),
          have_enqueued_job(JusticeGovSk::Decrees::ListCrawler).on_queue('decrees').with(page: 2),
          have_enqueued_job(JusticeGovSk::Decrees::ListCrawler).on_queue('decrees').with(page: 8332)
        )
      end
    end
  end

  describe '.pages' do
    it 'gets number of pages in the list' do
      VCR.use_cassette('justice_gov_sk/decree_list') do
        expect(JusticeGovSk::Decrees.pages).to eql(8332)
      end
    end
  end
end
