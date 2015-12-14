require 'rails_helper'
require 'lib/obcan_justice_sk/infrastructure_spec'

RSpec.describe ObcanJusticeSk::Decrees do
  it_behaves_like ObcanJusticeSk::Infrastructure do
    let(:list_crawler) { ObcanJusticeSk::Decrees::ListCrawler }
    let(:queue) { 'decrees' }
    let(:pages) { 8332 }
    let(:vcr_cassette_name) { 'obcan_justice_sk/decree_list' }
  end
end
