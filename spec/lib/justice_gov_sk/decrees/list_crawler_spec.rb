require 'rails_helper'

RSpec.describe JusticeGovSk::Decrees::ListCrawler do
  describe '.perform_later' do
    it 'crawls decree list by specified page' do
      crawler = double(:crawler)

      stub_const('JusticeGovSk::Decrees::ResourceCrawler', crawler)

      VCR.use_cassette('justice_gov_sk/decree_list_on_page_3') do |cassette|
        expect(crawler).to receive(:perform_later).with('https://obcan.justice.sk/infosud/-/infosud/i-detail/rozhodnutie/d83847dc-be23-4b7c-aa89-064848f4364b%3Ae501691e-2a79-4feb-aed7-1b689ef35cfd')
        expect(crawler).to receive(:perform_later).with('https://obcan.justice.sk/infosud/-/infosud/i-detail/rozhodnutie/873e3670-12fd-471b-90fd-e8863f810f52%3A2b92f0d2-8c0f-4a44-8449-bf24b1848ce2')
        expect(crawler).to receive(:perform_later).exactly(198).times

        JusticeGovSk::Decrees::ListCrawler.perform_later(page: 3)
      end
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
          JusticeGovSk::Decrees::ListCrawler.perform_later(page: 3)
        }.to have_enqueued_job(JusticeGovSk::Decrees::ListCrawler).with(page: 3).on_queue('decrees')
      end
    end
  end
end
