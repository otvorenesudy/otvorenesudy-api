require 'rails_helper'
require 'lib/justice_gov_sk/infrastructure_spec'

RSpec.describe JusticeGovSk::Hearings do
  it_behaves_like JusticeGovSk::Infrastructure do
    let(:list_crawler) { JusticeGovSk::Hearings::ListCrawler }
    let(:queue) { 'hearings' }
    let(:pages) { 584 }
    let(:vcr_cassette_name) { 'justice_gov_sk/hearing_list' }
  end
end
