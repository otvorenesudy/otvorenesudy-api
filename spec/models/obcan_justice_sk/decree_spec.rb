# == Schema Information
#
# Table name: obcan_justice_sk_decrees
#
#  id         :bigint           not null, primary key
#  guid       :string           not null
#  uri        :string           not null
#  data       :jsonb            not null
#  checksum   :string           not null
#  created_at :datetime         not null
#  updated_at :datetime         not null
#
require 'rails_helper'
require 'models/concerns/obcan_justice_sk/importable_spec'

RSpec.describe ObcanJusticeSk::Decree do
  it_behaves_like ObcanJusticeSk::Importable do
    let(:attributes) {
      {
        uri: 'https://obcan.justice.sk/infosud/-/infosud/i-detail/rozhodnutie/305e5973-67a3-4258-a19e-b1dd31f2d095%3A9e90c187-fe0c-4957-a0d2-5f508d6ade04',
        forma: 'Trestný rozkaz',
        sud: 'Okresný súd Dunajská Streda',
        sud_uri: 'https://obcan.justice.sk/infosud/-/infosud/detail/sud/111',
        sudca: 'JUDr. Mária Képessyová',
        sudca_uri: 'https://obcan.justice.sk/infosud/-/infosud/detail/sudca/666',
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
        pdf_uri: 'https://obcan.justice.sk/content/public/item/9e90c187-fe0c-4957-a0d2-5f508d6ade04',
        html: '<html></html>'
      }
    }

    let(:updated_attributes) { attributes.merge(forma: 'Rozhodnutie', sud: 'Okresný súd Prievidza') }
  end
end
