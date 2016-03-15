require 'spec_helper'
require 'genpro_gov_sk'

RSpec.describe GenproGovSk::ProsecutorsCrawler do
  describe '.crawl' do
    it 'crawls list of prosecutors', vcr: { cassette_name: 'genpro_gov_sk/prosecutors_list' } do
      prosecutors = GenproGovSk::ProsecutorsCrawler.crawl

      expect(prosecutors.size).to eql(945)
      expect(prosecutors.first).to eql(
        name: 'JUDr. Ingrid Adamcová',
        first: 'Ingrid',
        middle: nil,
        last: 'Adamcová'
      )
    end
  end
end

RSpec.describe GenproGovSk::ProsecutorsCrawler::Parser do
  describe '.parse_name' do
    it 'parses prosecutor name' do
      expect(described_class.parse_name('Volkai Peter, JUDr.')).to eql(name: 'JUDr. Peter Volkai', first: 'Peter', middle: nil, last: 'Volkai')
      expect(described_class.parse_name('Vandžurová Nehilová Beáta, JUDr.')).to eql(name: 'JUDr. Beáta Vandžurová Nehilová', first: 'Beáta', middle: 'Vandžurová', last: 'Nehilová')
      expect(described_class.parse_name('Al Ramadanová Alena, Mgr.')).to eql(name: 'Mgr. Alena Al Ramadanová', first: 'Alena', middle: 'Al', last: 'Ramadanová')
      expect(described_class.parse_name('Beňuchová Tatiana, JUDr. CSc.')).to eql(name: 'JUDr. Tatiana Beňuchová, CSc.', first: 'Tatiana', middle: nil, last: 'Beňuchová')
      expect(described_class.parse_name('Birčáková Miriama, JUDr. Ing.')).to eql(name: 'JUDr. Ing. Miriama Birčáková', first: 'Miriama', middle: nil, last: 'Birčáková')
    end
  end
end

