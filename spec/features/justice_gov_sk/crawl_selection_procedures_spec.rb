require 'rails_helper'

RSpec.feature 'JusticeGovSk SelectionProcedures' do
  scenario 'crawls list of selection procedures', vcr: { cassette_name: 'justice_gov_sk/crawl_selection_procedure_list' } do
    pending
    fail
  end
end
