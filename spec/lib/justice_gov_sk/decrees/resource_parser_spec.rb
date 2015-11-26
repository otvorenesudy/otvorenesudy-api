require 'spec_helper'
require 'justice_gov_sk'

RSpec.describe JusticeGovSk::Decrees::ResourceParser do
  describe '.parse' do
    it 'parses raw decree attributes' do
      VCR.use_cassette('justice_gov_sk/decree') do
        html = JusticeGovSk::Downloader.download('https://obcan.justice.sk/infosud/-/infosud/i-detail/rozhodnutie/305e5973-67a3-4258-a19e-b1dd31f2d095%3A9e90c187-fe0c-4957-a0d2-5f508d6ade04')

        attributes = JusticeGovSk::Decrees::ResourceParser.parse(html)

        expect(attributes).to eql(
          forma: 'Trestný rozkaz',
          sud: 'Okresný súd Dunajská Streda',
          sud_uri: 'https://obcan.justice.sk/infosud/-/infosud/detail/sud/111',
          sudca: 'JUDr. Mária Képessyová',
          sudca_uri: 'https://obcan.justice.sk/infosud/-/infosud/detail/sudca/666',
          datum_vydania_rozhodnutia: '21.11.2015',
          spisova_znacka: '0T/167/2015',
          identifikacne_cislo_spisu: '2215000304',
          oblast_pravnej_upravy: 'Poriadok vo verejných veciach - Trestné právo',
          povaha_rozhodnutia: 'Prvostupňové nenapadnuté opravnými prostriedkami',
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
          pdf_uri: 'https://obcan.justice.sk/content/public/item/9e90c187-fe0c-4957-a0d2-5f508d6ade04',
          html: html
        )
      end
    end
  end
end
