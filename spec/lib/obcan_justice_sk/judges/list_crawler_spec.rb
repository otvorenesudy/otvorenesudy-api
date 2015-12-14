require 'rails_helper'
require 'lib/obcan_justice_sk/list_crawler_spec'

RSpec.describe ObcanJusticeSk::Judges::ListCrawler do
  it_behaves_like ObcanJusticeSk::ListCrawler do
    let(:queue) { 'judges' }
    let(:resource_queue) { 'judge' }
    let(:resource_crawler) { ObcanJusticeSk::Judges::ResourceCrawler }
    let(:vcr_cassette_name) { 'obcan_justice_sk/judge_list_on_page_3' }
    let(:items) { 200 }

    let(:url) { ObcanJusticeSk::Judges.uri.build(page: 3) }
    let(:links) {[
      'https://obcan.justice.sk/infosud/-/infosud/reg-detail/sudca/sudca_1087',
      'https://obcan.justice.sk/infosud/-/infosud/reg-detail/sudca/sudca_873',
    ]}
  end
end
