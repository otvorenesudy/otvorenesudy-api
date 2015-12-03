require 'spec_helper'

describe JusticeGovSk::Hearings::ItemParser do
  let(:uri) { 'https://obcan.justice.sk/infosud/-/infosud/i-detail/pojednavanie/ed30b0e8-45d8-4e4d-9a89-208d4d4847d2' }
  let(:html) { JusticeGovSk::Downloader.download(uri) }

  describe '.parse' do
    it 'parses hearing', vcr: { cassette_name: 'justice_gov_sk/hearing' }do
      # TODO
    end
  end
end
