require 'rails_helper'
require 'lib/obcan_justice_sk/resource_crawler_spec'

RSpec.describe ObcanJusticeSk::Judges::ResourceCrawler do
  it_behaves_like ObcanJusticeSk::ResourceCrawler do
    let(:uri) { 'https://obcan.justice.sk/infosud/-/infosud/reg-detail/sudca/sudca_587' }
    let(:queue) { 'judge' }
    let(:parser) { class_double(ObcanJusticeSk::Judges::ResourceParser).as_stubbed_const }
    let(:repository) { class_double(Legacy::Judge).as_stubbed_const }
  end
end
