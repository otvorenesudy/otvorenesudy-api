require 'rails_helper'

RSpec.describe GenproGovSk::ProsecutorsMetadata do
  describe '.of' do
    it 'returns metadata for a name ommiting null values' do
      metadata = GenproGovSk::ProsecutorsMetadata.of('JUDr. Ingrid Adamcová')

      expect(metadata).to eql({ position: 'Vedúca organizačno-kontrolného oddelenia', organisation: 'Generálna prokuratúra', municipality: nil })
    end

    it 'returns metadata for name' do
      metadata = GenproGovSk::ProsecutorsMetadata.of('JUDr. Tomáš Balogh')

      expect(metadata).to eql({ position: 'Okresný prokurátor', organisation: 'Okresná prokuratúra', municipality: 'Martin' })
    end

    it 'returns empty metadata for judge with none of the values set' do
      metadata = GenproGovSk::ProsecutorsMetadata.of('Mgr. Silvia Adamovičová')

      expect(metadata).to eql({ position: nil, organisation: nil, municipality: nil })
    end

    it 'correctly capitalizes metadata values' do
      metadata = GenproGovSk::ProsecutorsMetadata.of('Mgr. Lucia Bačová')
      expect(metadata).to eql({ position: nil, organisation: 'Okresná prokuratúra', municipality: 'Košice II' })

      metadata = GenproGovSk::ProsecutorsMetadata.of('JUDr. Jozef Barabás')
      expect(metadata).to eql({ position: 'Námestník okresného prokurátora', organisation: 'Okresná prokuratúra', municipality: 'Spišská Nová Ves' })
    end
  end

  describe '.metadata' do
    it 'parses correct number of metadata' do
      expect(GenproGovSk::ProsecutorsMetadata.metadata.size).to eql(938)
    end
  end
end
