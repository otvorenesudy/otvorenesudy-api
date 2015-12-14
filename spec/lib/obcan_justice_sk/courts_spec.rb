require 'rails_helper'

RSpec.describe ObcanJusticeSk::Courts do
  describe '.crawl' do
    before :each do
      ActiveJob::Base.queue_adapter = :test
    end

    after :each do
      ActiveJob::Base.queue_adapter = :inline
    end

    it 'enqueues job for crawling list of judges' do
      expect {
        ObcanJusticeSk::Courts.crawl
      }.to have_enqueued_job(ObcanJusticeSk::Courts::ListCrawler).with(ObcanJusticeSk::Courts.uri).on_queue('courts')
    end
  end
end
