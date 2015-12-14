require 'rails_helper'
require 'lib/obcan_justice_sk/resource_crawler_spec'

RSpec.describe ObcanJusticeSk::Decrees::ResourceCrawler do
  it_behaves_like ObcanJusticeSk::ResourceCrawler do
    let(:uri) { 'https://obcan.justice.sk/infosud/-/infosud/i-detail/rozhodnutie/d83847dc-be23-4b7c-aa89-064848f4364b%3Ae501691e-2a79-4feb-aed7-1b689ef35cfd' }
    let(:queue) { 'decree' }
    let(:parser) { class_double(ObcanJusticeSk::Decrees::ResourceParser).as_stubbed_const }
    let(:repository) { class_double(ObcanJusticeSk::Decree).as_stubbed_const }
  end
end
