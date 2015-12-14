require 'rails_helper'
require 'lib/justice_gov_sk/infrastructure_spec'

RSpec.describe JusticeGovSk::Judges do
  it_behaves_like JusticeGovSk::Infrastructure do
    let(:list_crawler) { JusticeGovSk::Judges::ListCrawler }
    let(:queue) { 'judges' }
    let(:pages) { 8 }
    let(:vcr_cassette_name) { 'justice_gov_sk/judge_list' }
  end
end
