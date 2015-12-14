require 'rails_helper'

RSpec.feature 'JusticGovSk Decrees' do
  scenario 'crawls list of decrees', vcr: { cassette_name: 'obcan_justice_sk/crawl_decree_list' } do
    pending
    fail
  end
end
