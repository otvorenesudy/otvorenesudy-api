require 'spec_helper'
require 'justice_gov_sk'

RSpec.describe JusticeGovSk::Hearings::ItemParser do
  let(:uri) { 'https://obcan.justice.sk/infosud/-/infosud/i-detail/pojednavanie/5b341263-c6bc-4935-ab25-4fd56b288829' }
  let(:html) { JusticeGovSk::Downloader.download(uri) }

  describe '.parse' do
    it 'parses hearing', vcr: { cassette_name: 'justice_gov_sk/hearing' } do
      attributes = JusticeGovSk::Hearings::ItemParser.parse(html)

      expect(attributes).to eql({
        predmet: 'PO - určenie neexistencie práva na výkon zrážok zo mzdy',
        sud: 'Okresný súd Žiar n/H',
        sud_uri: 'https://obcan.justice.sk/infosud/-/infosud/detail/sud/146',
        sudca: 'Mgr. Daniel Koneracký',
        sudca_uri: 'https://obcan.justice.sk/infosud/-/infosud/detail/sudca/1749',
        datum_pojednavania: '26.8.2016',
        cas_pojednavania: '09:00',
        usek: 'Civilný',
        spisova_znacka: '18C/19/2014',
        identifikacne_cislo_spisu: '6414201836',
        forma_ukonu: 'Pojednávanie a rozhodnutie',
        poznamka: nil,
        navrhovatelia: [],
        odporcovia: [],
        miestnost: '32 - 2.poschodie'
      })
    end
  end
end
