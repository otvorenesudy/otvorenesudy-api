require 'spec_helper'
require 'justice_gov_sk'

RSpec.describe JusticeGovSk::Hearings::ResourceParser do
  let(:uri) { 'https://obcan.justice.sk/infosud/-/infosud/i-detail/pojednavanie/5b341263-c6bc-4935-ab25-4fd56b288829' }
  let(:html) { JusticeGovSk::Downloader.download(uri) }

  describe '.parse' do
    it 'parses hearing', vcr: { cassette_name: 'justice_gov_sk/hearing' } do
      attributes = JusticeGovSk::Hearings::ResourceParser.parse(html)

      expect(attributes).to eql({
        predmet: 'PO - určenie neexistencie práva na výkon zrážok zo mzdy',
        sud: 'Okresný súd Žiar nad Hronom',
        sud_uri: 'https://obcan.justice.sk/infosud/-/infosud/detail/sud/146',
        sudca: 'Mgr. Daniel Koneracký',
        sudca_uri: 'https://obcan.justice.sk/infosud/-/infosud/detail/sudca/1749',
        datum: '26.08.2016',
        cas: '09:00',
        usek: 'Civilný',
        spisova_znacka: '18C/19/2014',
        identifikacne_cislo_spisu: '6414201836',
        forma_ukonu: 'Pojednávanie a rozhodnutie',
        poznamka: nil,
        navrhovatelia: [],
        odporcovia: [],
        obzalovani: [],
        miestnost: '32 - 2.poschodie',
        html: html
      })
    end

    context 'when judge is missing' do
      let(:uri) { 'https://obcan.justice.sk/infosud/-/infosud/i-detail/pojednavanie/a3a3b07c-8e8b-4573-b984-8db094536029' }

      it 'correcly parses hearing', vcr: { cassette_name: 'justice_gov_sk/hearing_without_judge' } do
        attributes = JusticeGovSk::Hearings::ResourceParser.parse(html)

        expect(attributes).to eql({
          predmet: 'zaplatenie 720,00 eur s prísl.',
          sud: 'Okresný súd Liptovský Mikuláš',
          sud_uri: 'https://obcan.justice.sk/infosud/-/infosud/detail/sud/134',
          sudca: nil,
          sudca_uri: nil,
          datum: '11.12.2015',
          cas: '09:15',
          usek: 'Civilný',
          spisova_znacka: '7C/91/2014',
          identifikacne_cislo_spisu: '5614203528',
          forma_ukonu: 'Pojednávanie a rozhodnutie',
          poznamka: nil,
          navrhovatelia: [],
          odporcovia: [],
          obzalovani: [],
          miestnost: '138 - pojednávacia miestnosť',
          html: html
        })
      end
    end
  end
end
