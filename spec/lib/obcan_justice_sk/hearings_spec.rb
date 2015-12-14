require 'rails_helper'
require 'lib/obcan_justice_sk/infrastructure_spec'

RSpec.describe ObcanJusticeSk::Hearings do
  it_behaves_like ObcanJusticeSk::Infrastructure do
    let(:list_crawler) { ObcanJusticeSk::Hearings::ListCrawler }
    let(:queue) { 'hearings' }
    let(:pages) { 584 }
    let(:vcr_cassette_name) { 'obcan_justice_sk/hearing_list' }
  end
end
