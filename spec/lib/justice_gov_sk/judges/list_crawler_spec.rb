require 'rails_helper'
require 'lib/justice_gov_sk/list_crawler_spec'

RSpec.describe JusticeGovSk::Judges::ListCrawler do
  it_behaves_like JusticeGovSk::ListCrawler do
    let(:queue) { 'judges' }
    let(:resource_queue) { 'judge' }
    let(:resource_crawler) { JusticeGovSk::Judges::ResourceCrawler }
    let(:vcr_cassette_name) { 'justice_gov_sk/judge_list_on_page_3' }
    let(:items) { 200 }

    let(:url) { JusticeGovSk::Judges::URI.build(page: 3) }
    let(:links) {[
      'https://obcan.justice.sk/infosud/-/infosud/reg-detail/sudca/sudca_1087',
      'https://obcan.justice.sk/infosud/-/infosud/reg-detail/sudca/sudca_873',
    ]}
  end
end
