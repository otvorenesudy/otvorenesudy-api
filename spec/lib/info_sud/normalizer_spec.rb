# frozen_string_literal: true

require 'rails_helper'

RSpec.describe InfoSud::Normalizer do
  describe '.partition_legislation' do
    it 'partitions legislation' do
      expect(described_class.partition_legislation('/SK/ZZ/2005/36')).to eql(year: 2005, number: 36)
      expect(described_class.partition_legislation('/SK/ZZ/2005/36#paragraf-62')).to eql(year: 2005, number: 36,
                                                                                         paragraph: '62')
      expect(described_class.partition_legislation('/SK/ZZ/1996/234/#paragraf-58.odsek-2.pismeno-d')).to eql(
        number: 234, year: 1996, paragraph: '58', section: '2', letter: 'd'
      )
    end
  end
end
