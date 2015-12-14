require 'rails_helper'

RSpec.describe JusticeGovSk::Courts do
  describe '.crawl' do
    before :each do
      ActiveJob::Base.queue_adapter = :test
    end

    after :each do
      ActiveJob::Base.queue_adapter = :inline
    end

    it 'enqueues job for crawling list of judges' do
      expect {
        JusticeGovSk::Courts.crawl
      }.to have_enqueued_job(JusticeGovSk::Courts::ListCrawler).with(JusticeGovSk::Courts.uri).on_queue('courts')
    end
  end
end
