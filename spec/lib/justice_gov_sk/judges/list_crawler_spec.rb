require 'rails_helper'

RSpec.describe JusticeGovSk::Judges::ListCrawler do
  describe '.perform_later' do
    let(:url) { JusticeGovSk::Judges::URI.build_for(page: 3) }
    let(:links) {[
      'https://obcan.justice.sk/infosud/-/infosud/reg-detail/sudca/sudca_1087',
      'https://obcan.justice.sk/infosud/-/infosud/reg-detail/sudca/sudca_873',
      'https://obcan.justice.sk/infosud/-/infosud/reg-detail/sudca/sudca_28'
    ]}

    it 'crawls judges list by specified page', vcr: { cassette_name: 'justice_gov_sk/judge_list_on_page_3' } do
      crawler = class_double(JusticeGovSk::Judges::ResourceCrawler).as_stubbed_const

      expect(crawler).to receive(:perform_later).with(links[0])
      expect(crawler).to receive(:perform_later).with(links[1])
      expect(crawler).to receive(:perform_later).with(links[2])
      expect(crawler).to receive(:perform_later).exactly(197).times

      JusticeGovSk::Judges::ListCrawler.perform_later(url)
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
          JusticeGovSk::Judges::ListCrawler.perform_later(url)
        }.to have_enqueued_job(JusticeGovSk::Judges::ListCrawler).with(url).on_queue('judges')
      end

      it 'enqueues jobs for judges pages', vcr: { cassette_name: 'justice_gov_sk/judge_list_on_page_3' } do
        expect {
          JusticeGovSk::Judges::ListCrawler.new.perform(url)
        }.to satisfy(
          have_enqueued_job(JusticeGovSk::Judges::ResourceCrawler).with(links[0]).on_queue('judge'),
          have_enqueued_job(JusticeGovSk::Judges::ResourceCrawler).with(links[1]).on_queue('judge'),
          have_enqueued_job(JusticeGovSk::Judges::ResourceCrawler).with(links[2]).on_queue('judge'),
          have_enqueued_job(JusticeGovSk::Judges::ResourceCrawler).on_queue('judge').exactly(200).times
        )
      end
    end
  end
end
