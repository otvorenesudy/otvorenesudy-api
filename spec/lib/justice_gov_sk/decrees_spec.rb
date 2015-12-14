require 'rails_helper'
require 'lib/justice_gov_sk/infrastructure_spec'

RSpec.describe JusticeGovSk::Decrees do
  it_behaves_like JusticeGovSk::Infrastructure do
    let(:list_crawler) { JusticeGovSk::Decrees::ListCrawler }
    let(:queue) { 'decrees' }
    let(:pages) { 8332 }
    let(:vcr_cassette_name) { 'justice_gov_sk/decree_list' }
  end
end
