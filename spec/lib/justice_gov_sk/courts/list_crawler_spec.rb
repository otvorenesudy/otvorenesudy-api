require 'rails_helper'
require 'lib/justice_gov_sk/list_crawler_spec'

RSpec.describe JusticeGovSk::Courts::ListCrawler do
  it_behaves_like JusticeGovSk::ListCrawler do
    let(:queue) { 'courts' }
    let(:resource_queue) { 'court' }
    let(:resource_crawler) { JusticeGovSk::Courts::ResourceCrawler }
    let(:vcr_cassette_name) { 'justice_gov_sk/court_list_on_page_3' }
    let(:items) { 64 }

    let(:url) { JusticeGovSk::Courts.uri }
    let(:links) {[
      'https://obcan.justice.sk/infosud/-/infosud/reg-detail/sud/sud_100',
      'https://obcan.justice.sk/infosud/-/infosud/reg-detail/sud/sud_130',
      'https://obcan.justice.sk/infosud/-/infosud/reg-detail/sud/sud_157'
    ]}
  end
end
