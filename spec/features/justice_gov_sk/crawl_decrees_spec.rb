require 'rails_helper'

RSpec.feature 'JusticGovSk Decrees' do
  scenario 'crawls list of decrees', vcr: { cassette_name: 'justice_gov_sk/crawl_decree_list' } do
    pending
    fail
  end
end
