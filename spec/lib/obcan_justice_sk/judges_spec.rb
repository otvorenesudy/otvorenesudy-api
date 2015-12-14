require 'rails_helper'
require 'lib/obcan_justice_sk/infrastructure_spec'

RSpec.describe ObcanJusticeSk::Judges do
  it_behaves_like ObcanJusticeSk::Infrastructure do
    let(:list_crawler) { ObcanJusticeSk::Judges::ListCrawler }
    let(:queue) { 'judges' }
    let(:pages) { 8 }
    let(:vcr_cassette_name) { 'obcan_justice_sk/judge_list' }
  end
end
