# frozen_string_literal: true

require 'rails_helper'

RSpec.describe GenproGovSk::ProsecutorsCrawler do
  describe '.crawl' do
    it 'crawls the list of prosecutors, each by their name', vcr: { cassette_name: 'genpro_gov_sk/prosecutors_list' } do
      prosecutors = described_class.crawl

      expect(prosecutors.size).to be(942)
      expect(prosecutors.first).to eq(value: 'JUDr. Ingrid Adamcová', first: 'Ingrid', middle: nil, last: 'Adamcová')
    end
  end

  describe GenproGovSk::ProsecutorsCrawler::Parser do
    describe '.parse_name' do
      {
        'Volkai Peter, JUDr.' => ['JUDr. Peter Volkai', 'Peter', nil, 'Volkai'],
        'Vandžurová Nehilová Beáta, JUDr.' => ['JUDr. Beáta Vandžurová Nehilová', 'Beáta', 'Vandžurová', 'Nehilová'],
        'Al Ramadanová Alena, Mgr.' => ['Mgr. Alena Al Ramadanová', 'Alena', 'Al', 'Ramadanová'],
        'Beňuchová Tatiana, JUDr. CSc.' => ['JUDr. Tatiana Beňuchová, CSc.', 'Tatiana', nil, 'Beňuchová'],
        'Birčáková Miriama, JUDr. Ing.' => ['JUDr. Ing. Miriama Birčáková', 'Miriama', nil, 'Birčáková']
      }.each do |name, (value, first, middle, last)|
        it "parses #{name}" do
          expect(described_class.parse_name(name)).to eq(value:, first:, middle:, last:)
        end
      end
    end
  end
end
