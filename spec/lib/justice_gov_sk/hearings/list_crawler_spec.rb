require 'rails_helper'

RSpec.describe JusticeGovSk::Hearings::ListCrawler do
  let(:links) {[
    'https://obcan.justice.sk/infosud/-/infosud/i-detail/pojednavanie/f295813a-af35-49ad-8be1-cfc3bc77ccbf',
    'https://obcan.justice.sk/infosud/-/infosud/i-detail/pojednavanie/922eace7-a6f5-4843-9446-b4fba2322178'
  ]}

  describe '.perform_later' do
    it 'crawls hearings list by specified page', vcr: { cassette_name: 'justice_gov_sk/hearing_list_on_page_3' } do
      crawler = class_double(JusticeGovSk::Hearings::ResourceCrawler).as_stubbed_const

      expect(crawler).to receive(:perform_later).with(links[0])
      expect(crawler).to receive(:perform_later).with(links[1])
      expect(crawler).to receive(:perform_later).exactly(198).times

      JusticeGovSk::Hearings::ListCrawler.perform_later(page: 3)
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
          JusticeGovSk::Hearings::ListCrawler.perform_later(page: 3)
        }.to have_enqueued_job(JusticeGovSk::Hearings::ListCrawler).with(page: 3).on_queue('hearings')
      end

      it 'enqueues jobs for hearing pages', vcr: { cassette_name: 'justice_gov_sk/hearing_list_on_page_3' } do
        expect {
          JusticeGovSk::Hearings::ListCrawler.new.perform(page: 3)
        }.to satisfy(
          have_enqueued_job(JusticeGovSk::Hearings::ResourceCrawler).with(links[0]).on_queue('hearing'),
          have_enqueued_job(JusticeGovSk::Hearings::ResourceCrawler).with(links[1]).on_queue('hearing'),
          have_enqueued_job(JusticeGovSk::Hearings::ResourceCrawler).on_queue('hearing').exactly(200).times
        )
      end
    end
  end
end
