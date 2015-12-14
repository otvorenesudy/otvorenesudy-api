require 'rails_helper'
require 'lib/justice_gov_sk/resource_crawler_spec'

RSpec.describe JusticeGovSk::Courts::ResourceCrawler do
  it_behaves_like JusticeGovSk::ResourceCrawler do
    let(:uri) { 'https://obcan.justice.sk/infosud/-/infosud/reg-detail/sud/sud_100' }
    let(:queue) { 'court' }
    let(:parser) { class_double(JusticeGovSk::Courts::ResourceParser).as_stubbed_const }
    let(:repository) { class_double(JusticeGovSk::Court).as_stubbed_const }
  end
end
