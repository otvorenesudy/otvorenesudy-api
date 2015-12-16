require 'rails_helper'
require 'lib/obcan_justice_sk/resource_crawler_spec'

RSpec.describe ObcanJusticeSk::Courts::ResourceCrawler do
  it_behaves_like ObcanJusticeSk::ResourceCrawler do
    let(:uri) { 'https://obcan.justice.sk/infosud/-/infosud/reg-detail/sud/sud_100' }
    let(:queue) { 'court' }
    let(:parser) { class_double(ObcanJusticeSk::Courts::ResourceParser).as_stubbed_const }
    let(:repository) { class_double(Legacy::Court).as_stubbed_const }
  end
end
