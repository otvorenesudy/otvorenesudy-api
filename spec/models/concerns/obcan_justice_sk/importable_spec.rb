require 'rails_helper'

RSpec.shared_examples_for ObcanJusticeSk::Importable do
  let(:record) { described_class.find_by(guid: attributes[:guid]) }
  let(:uri) { 'https://example.com' }
  let(:attributes) { { guid: '1', category: { attribute: [id: '1', name: 'Example'] } } }
  let(:updated_attributes) { attributes.merge!(category: { attribute: [id: '2', name: 'Example'] }) }

  describe '.import_from' do
    it 'imports record by attributes' do
      described_class.import_from!(guid: attributes[:guid], uri: uri, data: attributes)

      record_attributes = record.attributes.symbolize_keys.except(:id, :created_at, :updated_at)

      expect(record_attributes.deep_symbolize_keys).to eql(
        guid: attributes[:guid],
        uri: uri,
        data: attributes,
        checksum: Digest::SHA256.hexdigest(attributes.to_json)
      )
    end

    context 'when record is already imported' do
      it 'updates record' do
        described_class.import_from!(guid: attributes[:guid], uri: uri, data: attributes)
        described_class.import_from!(guid: attributes[:guid], uri: uri, data: updated_attributes)

        record_attributes = record.attributes.symbolize_keys.except(:id, :created_at, :updated_at)

        expect(record_attributes.deep_symbolize_keys).to eql(
          guid: updated_attributes[:guid],
          uri: uri,
          data: updated_attributes,
          checksum: Digest::SHA256.hexdigest(updated_attributes.to_json)
        )
      end

      context 'without any change' do
        it 'does not update record' do
          time = 30.minutes.ago

          Timecop.freeze(time) { described_class.import_from!(guid: attributes[:guid], uri: uri, data: attributes) }

          described_class.import_from!(guid: attributes[:guid], uri: uri, data: attributes)

          record_attributes = record.attributes.symbolize_keys.except(:id, :created_at, :updated_at)

          expect(record.updated_at.change(usec: 0)).to eq(time.change(usec: 0))
          expect(record_attributes.deep_symbolize_keys).to eql(
            guid: attributes[:guid],
            uri: uri,
            data: attributes,
            checksum: Digest::SHA256.hexdigest(attributes.to_json)
          )
        end
      end
    end
  end
end
