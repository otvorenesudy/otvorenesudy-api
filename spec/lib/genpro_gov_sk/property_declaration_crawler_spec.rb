# frozen_string_literal: true

require 'rails_helper'

RSpec.describe GenproGovSk::PropertyDeclarationCrawler do
  describe '.crawl' do
    def crawl(id)
      described_class.crawl("https://www.genpro.gov.sk/prokuratura-sr/majetkove-priznania-30a3.html?id=#{id}")
    end

    def statement(incomes)
      [
        'Vyhlasujem, že spĺňam podmienky osvedčenia podľa § 27 ods. 1 zák. č. 154/2001 Z.z.',
        "Vyhlasujem, že z činností podľa § 27 ods. 2 zák. č. 154/2001 Z.z. mi #{incomes} príjmy a pôžitky."
      ]
    end

    it 'reads the year, each list of property with its items, and the statements of a declaration',
       vcr: { cassette_name: 'genpro_gov_sk/property_declaration' } do
      declaration = crawl(7361)

      expect(declaration.slice(:year, :statements)).to eq(year: 2011, statements: statement('neplynú'))
      expect(declaration[:lists].map { [it[:category], it[:items].first] }).to eq(
        [
          [
            'Zoznam nehnuteľností',
            { description: 'rodinný dom', acquisition_reason: 'úspory', acquisition_date: '27. 1. 2010' }
          ],
          [
            'Hnuteľné veci',
            { description: 'osobné motorové vozidlo', acquisition_reason: 'kúpa, úspory',
              acquisition_date: '28. 4. 2011' }
          ]
        ]
      )
    end

    it 'reads the incomes of a declaration that has them',
       vcr: { cassette_name: 'genpro_gov_sk/property_declaration_with_incomes' } do
      declaration = crawl(7281)

      expect(declaration.slice(:year, :statements)).to eq(year: 2011, statements: statement('plynú'))
      expect(declaration[:lists].pluck(:category)).to eq(
        ['Zoznam nehnuteľností', 'Hnuteľné veci', 'Hnuteľné veci, majetkové práva a iné majetkové práva',
         'Príjmy a iné pôžitky']
      )
      expect(declaration[:lists].first(3).map { [it[:items].size, it[:items].first] }).to eq(
        [
          [5, { description: 'zastavané plochy', acquisition_reason: 'dar', acquisition_date: '12. 7. 2007' }],
          [3, { description: 'auto', acquisition_reason: 'kúpa', acquisition_date: '30. 10. 2006' }],
          [1, { description: 'hypotekárny úver', acquisition_date: '30. 5. 2003' }]
        ]
      )
      expect(declaration[:incomes]).to eq([{ description: 'lektorská činnosť', value: '607 Eur' }])
    end
  end

  describe GenproGovSk::PropertyDeclarationCrawler::Parser do
    describe '.parse' do
      let(:html) do
        <<~HTML
          <div id="page"><div class="contentIntro"><div class="grid_9 contentPage">
            <h3>Majetkové priznanie za rok 2012</h3>
            <table class="table_01">
              <caption>Príjmy a iné pôžitky</caption>
              <tr class="rowBlue_02"><th>zdroj</th><th>suma</th></tr>
              <tr><td>lektorská činnosť</td><td>607 Eur</td></tr>
            </table>
          </div></div></div>
        HTML
      end

      it 'reads no incomes from a table of incomes laid out in a way it does not know, and says so' do
        declaration = nil

        expect { declaration = described_class.parse(html) }.to output(/No parser for \["zdroj", "suma"\]/).to_stderr
        expect(declaration.slice(:year, :incomes)).to eq(year: 2012, incomes: nil)
      end
    end
  end
end
