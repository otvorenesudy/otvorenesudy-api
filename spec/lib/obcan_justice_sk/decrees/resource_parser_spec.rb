require 'spec_helper'
require 'obcan_justice_sk'

RSpec.describe ObcanJusticeSk::Decrees::ResourceParser do
  let(:uri) { 'https://obcan.justice.sk/infosud/-/infosud/i-detail/rozhodnutie/305e5973-67a3-4258-a19e-b1dd31f2d095%3A9e90c187-fe0c-4957-a0d2-5f508d6ade04' }
  let(:html) { ObcanJusticeSk::Downloader.download(uri) }

  describe '.parse' do
    it 'parses raw decree attributes', vcr: { cassette_name: 'obcan_justice_sk/decree' } do
      attributes = ObcanJusticeSk::Decrees::ResourceParser.parse(html)

      expect(attributes).to eql(
        forma: 'Trestný rozkaz',
        sud: 'Okresný súd Dunajská Streda',
        sud_uri: 'https://obcan.justice.sk/infosud/-/infosud/detail/sud/111',
        sudca: 'JUDr. Mária Képessyová',
        sudca_uri: 'https://obcan.justice.sk/infosud/-/infosud/detail/sudca/666?_isufront_WAR_isufront_detailPart=SUDCA_ROZHODNUTIA',
        datum: '21.11.2015',
        spisova_znacka: '0T/167/2015',
        identifikacne_cislo_spisu: '2215000304',
        oblast_pravnej_upravy: 'Poriadok vo verejných veciach - Trestné právo',
        povaha: 'Prvostupňové nenapadnuté opravnými prostriedkami',
        ecli: 'ECLI:SK:OSDS:2015:2215000304.1',
        predpisy: [
          '/SK/ZZ/2005/300/#paragraf-37',
          '/SK/ZZ/2005/300/#paragraf-38.odsek-2',
          '/SK/ZZ/2005/300',
          '/SK/ZZ/2005/300/#paragraf-61.odsek-2',
          '/SK/ZZ/2005/300/#paragraf-50.odsek-1',
          '/SK/ZZ/2005/300/#paragraf-36',
          '/SK/ZZ/2005/300/#paragraf-348.odsek-1',
          '/SK/ZZ/2005/300/#paragraf-61.odsek-1',
          '/SK/ZZ/2005/300/#paragraf-49.odsek-1.pismeno-a'
        ],
        pdf_uri: 'https://obcan.justice.sk/content/public/item/9e90c187-fe0c-4957-a0d2-5f508d6ade04'
      )
    end

    context 'when link to judge is missing' do
      let(:uri) { 'https://obcan.justice.sk/infosud/-/infosud/i-detail/rozhodnutie/83621225-46c2-409d-8aa5-3c0e3830998a%3A53191bda-9a39-4687-b75d-0a008ff13213' }

      it 'correctly parses the decree', vcr: { cassette_name: 'obcan_justice_sk/decree_without_judge_uri' } do
        attributes = ObcanJusticeSk::Decrees::ResourceParser.parse(html)

        expect(attributes).to eql(
          forma: 'Rozhodnutie',
          sud: 'Okresný súd Rimavská Sobota',
          sud_uri: 'https://obcan.justice.sk/infosud/-/infosud/detail/sud/143',
          sudca: 'JUDr. Alexandra Guliková',
          sudca_uri: nil,
          datum: '19.11.2015',
          spisova_znacka: '8C/486/2015',
          identifikacne_cislo_spisu: '6915213805',
          oblast_pravnej_upravy: nil,
          povaha: nil,
          ecli: 'ECLI:SK:OSRS:2015:6915213805.1',
          predpisy: [],
          pdf_uri: 'https://obcan.justice.sk/content/public/item/53191bda-9a39-4687-b75d-0a008ff13213'
        )
      end
    end
  end
end
