require 'rails_helper'

RSpec.feature 'JusticGovSk Hearings' do
  scenario 'crawls list of hearings', vcr: { cassette_name: 'justice_gov_sk/crawl_hearing_list' } do
    pending
    fail
  end
end
