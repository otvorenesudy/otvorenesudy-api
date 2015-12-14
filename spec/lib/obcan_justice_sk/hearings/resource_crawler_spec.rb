require 'rails_helper'
require 'lib/obcan_justice_sk/resource_crawler_spec'

RSpec.describe ObcanJusticeSk::Hearings::ResourceCrawler do
  it_behaves_like ObcanJusticeSk::ResourceCrawler do
    let(:uri) { 'https://obcan.justice.sk/infosud/-/infosud/i-detail/pojednavanie/5b341263-c6bc-4935-ab25-4fd56b288829' }
    let(:queue) { 'hearing' }
    let(:parser) { class_double(ObcanJusticeSk::Hearings::ResourceParser).as_stubbed_const }
    let(:repository) { class_double(ObcanJusticeSk::Hearing).as_stubbed_const }
  end
end
