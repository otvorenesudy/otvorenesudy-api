require 'rails_helper'
require 'lib/justice_gov_sk/resource_crawler_spec'

RSpec.describe JusticeGovSk::Judges::ResourceCrawler do
  it_behaves_like JusticeGovSk::ResourceCrawler do
    let(:uri) { 'https://obcan.justice.sk/infosud/-/infosud/reg-detail/sudca/sudca_587' }
    let(:queue) { 'judge' }
    let(:parser) { class_double(JusticeGovSk::Judges::ResourceParser).as_stubbed_const }
    let(:repository) { class_double(JusticeGovSk::Judge).as_stubbed_const }
  end
end
