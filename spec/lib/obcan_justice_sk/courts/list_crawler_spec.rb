require 'rails_helper'
require 'lib/obcan_justice_sk/list_crawler_spec'

RSpec.describe ObcanJusticeSk::Courts::ListCrawler do
  it_behaves_like ObcanJusticeSk::ListCrawler do
    let(:queue) { 'courts' }
    let(:resource_queue) { 'court' }
    let(:resource_crawler) { ObcanJusticeSk::Courts::ResourceCrawler }
    let(:vcr_cassette_name) { 'obcan_justice_sk/court_list_on_page_3' }
    let(:items) { 64 }

    let(:url) { ObcanJusticeSk::Courts.uri }
    let(:links) {[
      'https://obcan.justice.sk/infosud/-/infosud/reg-detail/sud/sud_100',
      'https://obcan.justice.sk/infosud/-/infosud/reg-detail/sud/sud_130',
      'https://obcan.justice.sk/infosud/-/infosud/reg-detail/sud/sud_157'
    ]}
  end
end
