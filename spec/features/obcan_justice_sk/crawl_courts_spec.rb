require 'rails_helper'

RSpec.feature 'JusticGovSk Courts' do
  scenario 'crawls list of courts', vcr: { cassette_name: 'obcan_justice_sk/crawl_court_list' } do
    pending
    fail
  end
end
