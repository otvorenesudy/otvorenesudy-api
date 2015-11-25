require 'spec_helper'
require 'justice_gov_sk'

RSpec.describe JusticeGovSk::Decrees do
  describe '.pages' do
    it 'gets number of pages in the list' do
      VCR.use_cassette('justice_gov_sk/decree_list') do
        expect(JusticeGovSk::Decrees.pages).to eql(8332)
      end
    end
  end
end
