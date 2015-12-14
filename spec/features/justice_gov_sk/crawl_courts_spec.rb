require 'rails_helper'

RSpec.feature 'JusticGovSk Courts' do
  scenario 'crawls list of courts', vcr: { cassette_name: 'justice_gov_sk/crawl_court_list' } do
    pending
    fail
  end
end
