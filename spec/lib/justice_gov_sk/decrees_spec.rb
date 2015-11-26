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
      # TODO check correct params

      VCR.use_cassette('justice_gov_sk/decree_list') do
        expect {
          JusticeGovSk::Decrees.crawl
        }.to have_enqueued_job(JusticeGovSk::Decrees::ListCrawler).on_queue('decrees').exactly(8332).times
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
