require 'rails_helper'
require 'lib/justice_gov_sk/resource_crawler_spec'

RSpec.describe JusticeGovSk::Hearings::ResourceCrawler do
  it_behaves_like JusticeGovSk::ResourceCrawler do
    let(:uri) { 'https://obcan.justice.sk/infosud/-/infosud/i-detail/pojednavanie/5b341263-c6bc-4935-ab25-4fd56b288829' }
    let(:queue) { 'hearing' }
    let(:parser) { class_double(JusticeGovSk::Hearings::ResourceParser).as_stubbed_const }
    let(:repository) { class_double(JusticeGovSk::Hearing).as_stubbed_const }
  end
end
