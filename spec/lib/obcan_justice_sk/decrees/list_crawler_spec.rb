require 'rails_helper'
require 'lib/obcan_justice_sk/list_crawler_spec'

RSpec.describe ObcanJusticeSk::Decrees::ListCrawler do
  it_behaves_like ObcanJusticeSk::ListCrawler do
    let(:queue) { 'decrees' }
    let(:resource_queue) { 'decree' }
    let(:resource_crawler) { ObcanJusticeSk::Decrees::ResourceCrawler }
    let(:vcr_cassette_name) { 'obcan_justice_sk/decree_list_on_page_3' }
    let(:items) { 200 }

    let(:url) { ObcanJusticeSk::Decrees.uri.build(page: 3) }
    let(:links) {[
      'https://obcan.justice.sk/infosud/-/infosud/i-detail/rozhodnutie/d83847dc-be23-4b7c-aa89-064848f4364b%3Ae501691e-2a79-4feb-aed7-1b689ef35cfd',
      'https://obcan.justice.sk/infosud/-/infosud/i-detail/rozhodnutie/873e3670-12fd-471b-90fd-e8863f810f52%3A2b92f0d2-8c0f-4a44-8449-bf24b1848ce2'
    ]}
  end
end
