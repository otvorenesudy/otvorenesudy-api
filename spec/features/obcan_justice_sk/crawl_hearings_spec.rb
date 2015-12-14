require 'rails_helper'

RSpec.feature 'JusticGovSk Hearings' do
  scenario 'crawls list of hearings', vcr: { cassette_name: 'obcan_justice_sk/crawl_hearing_list' } do
    pending
    fail
  end
end
