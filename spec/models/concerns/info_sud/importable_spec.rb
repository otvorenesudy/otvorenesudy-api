require 'rails_helper'

RSpec.shared_examples_for InfoSud::Importable do
  let(:record) { described_class.find_by(guid: attributes[:guid]) }
  let(:attributes) { { guid: '1', category: { attribute: [id: '1', name: 'Example'] } } }
  let(:updated_attributes) { attributes.merge!(category: { attribute: [id: '2', name: 'Example'] }) }

  describe '.import_from' do
    it 'imports record by attributes' do
      described_class.import_from(attributes)

      record_attributes = record.attributes.symbolize_keys.except(:id, :created_at, :updated_at)

      expect(record_attributes.deep_symbolize_keys).to eql(guid: attributes[:guid], data: attributes)
    end

    it 'filters unrelevant attributes' do
      described_class.import_from(attributes)

      described_class.filtered_attributes_for_import.each { |name| attributes[name] = rand.to_s }

      record_attributes = record.attributes.symbolize_keys.except(:id, :created_at, :updated_at)

      expect(record_attributes.deep_symbolize_keys).to eql(
        guid: attributes[:guid],
        data: attributes.except(*described_class.filtered_attributes_for_import)
      )
    end

    context 'when record is already imported' do
      it 'updates record' do
        described_class.import_from(attributes)
        described_class.import_from(updated_attributes)

        record_attributes = record.attributes.symbolize_keys.except(:id, :created_at, :updated_at)

        expect(record_attributes.deep_symbolize_keys).to eql(guid: updated_attributes[:guid], data: attributes)
      end

      context 'without any change' do
        it 'does not update record' do
          time = 30.minutes.ago

          Timecop.freeze(time) { described_class.import_from(attributes) }

          described_class.import_from(attributes)

          record_attributes = record.attributes.symbolize_keys.except(:id, :created_at, :updated_at)

          expect(record.updated_at.change(usec: 0)).to eq(time.change(usec: 0))
          expect(record_attributes.deep_symbolize_keys).to eql(guid: attributes[:guid], data: attributes)
        end
      end
    end
  end
end
