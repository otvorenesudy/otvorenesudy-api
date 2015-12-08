require 'rails_helper'
require 'lib/justice_gov_sk/list_crawler_spec'

RSpec.describe JusticeGovSk::Hearings::ListCrawler do
  it_behaves_like JusticeGovSk::ListCrawler do
    let(:queue) { 'hearings' }
    let(:resource_queue) { 'hearing' }
    let(:resource_crawler) { JusticeGovSk::Hearings::ResourceCrawler }
    let(:vcr_cassette_name) { 'justice_gov_sk/hearing_list_on_page_3' }

    let(:url) { JusticeGovSk::Hearings::URI.build(page: 3) }
    let(:links) {[
      'https://obcan.justice.sk/infosud/-/infosud/i-detail/pojednavanie/f295813a-af35-49ad-8be1-cfc3bc77ccbf',
      'https://obcan.justice.sk/infosud/-/infosud/i-detail/pojednavanie/922eace7-a6f5-4843-9446-b4fba2322178'
    ]}
  end
end
