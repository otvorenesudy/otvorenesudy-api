require 'spec_helper'
require 'genpro_gov_sk'

RSpec.describe GenproGovSk::PropertyDeclarationCrawler do
  describe '.crawl' do
    it 'crawls property declaration for prosecutor', vcr: { cassette_name: 'genpro_gov_sk/property_declaration' } do
      declaration = GenproGovSk::PropertyDeclarationCrawler.crawl('https://www.genpro.gov.sk/prokuratura-sr/majetkove-priznania-30a3.html?id=7361')

      expect(declaration[:year]).to eql(2011)
      expect(declaration[:lists].size).to eql(2)
      expect(declaration[:lists].map { |e| e[:category] }).to eql(['Zoznam nehnuteľností', 'Hnuteľné veci'])

      items = declaration[:lists][0][:items]

      expect(items[0]).to eql(description: 'rodinný dom', acquisition_reason: 'úspory', acquisition_date: '27. 1. 2010')

      items = declaration[:lists][1][:items]

      expect(items[0]).to eql(description: 'osobné motorové vozidlo', acquisition_reason: 'kúpa, úspory', acquisition_date: '28. 4. 2011')

      expect(declaration[:statements]).to eql([
        'Vyhlasujem, že spĺňam podmienky osvedčenia podľa § 27 ods. 1 zák. č. 154/2001 Z.z.',
        'Vyhlasujem, že z činností podľa § 27 ods. 2 zák. č. 154/2001 Z.z. mi neplynú príjmy a pôžitky.'
      ])
    end

    it 'parses property declarations for prosecutor with incomes', vcr: { cassette_name: 'genpro_gov_sk/property_declaration_with_incomes' } do
      declaration = GenproGovSk::PropertyDeclarationCrawler.crawl('https://www.genpro.gov.sk/prokuratura-sr/majetkove-priznania-30a3.html?id=7281')

      expect(declaration[:year]).to eql(2011)
      expect(declaration[:lists].size).to eql(4)
      expect(declaration[:lists].map { |e| e[:category] }).to eql(['Zoznam nehnuteľností', 'Hnuteľné veci', 'Hnuteľné veci, majetkové práva a iné majetkové práva', 'Príjmy a iné pôžitky'])

      items = declaration[:lists][0][:items]

      expect(items.size).to eql(5)
      expect(items[0]).to eql(description: 'zastavané plochy', acquisition_reason: 'dar', acquisition_date: '12. 7. 2007')

      items = declaration[:lists][1][:items]

      expect(items.size).to eql(3)
      expect(items[0]).to eql(description: 'auto', acquisition_reason: 'kúpa', acquisition_date: '30. 10. 2006')

      items = declaration[:lists][2][:items]

      expect(items.size).to eql(1)
      expect(items[0]).to eql(description: 'hypotekárny úver', acquisition_date: '30. 5. 2003')

      items = declaration[:incomes]

      expect(items.size).to eql(1)
      expect(items[0]).to eql(description: 'lektorská činnosť', value: '607 Eur')

      expect(declaration[:statements]).to eql([
        'Vyhlasujem, že spĺňam podmienky osvedčenia podľa § 27 ods. 1 zák. č. 154/2001 Z.z.',
        'Vyhlasujem, že z činností podľa § 27 ods. 2 zák. č. 154/2001 Z.z. mi plynú príjmy a pôžitky.'
      ])
    end
  end
end
