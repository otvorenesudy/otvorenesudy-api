require 'rails_helper'

RSpec.describe ObcanJusticeSk::Courts do
  describe '.crawl', active_job: { adapter: :test } do
    it 'enqueues job for crawling list of judges' do
      expect {
        ObcanJusticeSk::Courts.crawl
      }.to have_enqueued_job(ObcanJusticeSk::Courts::ListCrawler).with(ObcanJusticeSk::Courts.uri).on_queue('courts')
    end
  end
end
