require 'spec_helper'
require 'genpro_gov_sk'

RSpec.describe GenproGovSk::PropertyDeclarationsCrawler do
  describe '.crawl' do
    let(:declarations) { [double(:declaration)] }

    it 'crawls property declarations' do
      allow(GenproGovSk::ProsecutorsCrawler).to receive(:crawl) { [{ first: 'Peter', middle: 'John', last: 'Pan', value: 'Peter John Pan' }] }
      expect(GenproGovSk::PropertyDeclarationsCrawler).to receive(:crawl_for).with(first_name: 'Peter', last_name: 'John Pan') { declarations }
      allow(GenproGovSk::ProsecutorsMetadata).to receive(:of).with('Peter John Pan') { { position: 'Head of Court' } }

      expect(GenproGovSk::PropertyDeclarationsCrawler.crawl).to eql([
        {
          name: {
            first: 'Peter',
            middle: 'John',
            last: 'Pan',
            value: 'Peter John Pan'
          },

          position: 'Head of Court',
          property_declarations: declarations
        }
      ])
    end
  end

  describe '.crawl_for' do
    it 'crawls property declarations by first and last name of prosecutor', vcr: { cassette_name: 'genpro_gov_sk/property_declarations_list' } do
      expect(GenproGovSk::PropertyDeclarationCrawler).to receive(:crawl).with('https://www.genpro.gov.sk/prokuratura-sr/majetkove-priznania-30a3.html?id=7361')
      expect(GenproGovSk::PropertyDeclarationCrawler).to receive(:crawl).with('https://www.genpro.gov.sk/prokuratura-sr/majetkove-priznania-30a3.html?id=18311')
      expect(GenproGovSk::PropertyDeclarationCrawler).to receive(:crawl).with('https://www.genpro.gov.sk/prokuratura-sr/majetkove-priznania-30a3.html?id=27981')
      expect(GenproGovSk::PropertyDeclarationCrawler).to receive(:crawl).with('https://www.genpro.gov.sk/prokuratura-sr/majetkove-priznania-30a3.html?id=37631')

      GenproGovSk::PropertyDeclarationsCrawler.crawl_for(first_name: 'Beáta', last_name: 'Vandžurová Nehilová')
    end
  end
end
