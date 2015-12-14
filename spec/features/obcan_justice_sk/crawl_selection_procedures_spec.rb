require 'rails_helper'

RSpec.feature 'ObcanJusticeSk SelectionProcedures' do
  scenario 'crawls list of selection procedures', vcr: { cassette_name: 'obcan_justice_sk/crawl_selection_procedure_list' } do
    pending
    fail
  end
end
