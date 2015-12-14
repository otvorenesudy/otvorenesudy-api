require 'rails_helper'

RSpec.feature 'JusticGovSk Judges' do
  scenario 'crawls list of judges', vcr: { cassette_name: 'justice_gov_sk/crawl_judges_list' } do
    pending
    fail
  end
end
