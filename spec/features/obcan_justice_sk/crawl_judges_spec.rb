require 'rails_helper'

RSpec.feature 'JusticGovSk Judges' do
  scenario 'crawls list of judges', vcr: { cassette_name: 'obcan_justice_sk/crawl_judges_list' } do
    pending
    fail
  end
end
