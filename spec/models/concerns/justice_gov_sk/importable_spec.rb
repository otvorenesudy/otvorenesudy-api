require 'rails_helper'

RSpec.shared_examples_for JusticeGovSk::Importable do
  describe '.import_from' do
    it 'imports record by attributes' do
      described_class.import_from(attributes)

      record = described_class.find_by(uri: attributes[:uri])
      record_attributes = record.attributes.symbolize_keys.except(:id, :created_at, :updated_at)

      expect(record_attributes).to eql(attributes)
    end

    context 'when record is already imported' do
      it 'updates record' do
        described_class.import_from(attributes)
        described_class.import_from(updated_attributes)

        record = described_class.find_by(uri: attributes[:uri])
        record_attributes = record.attributes.symbolize_keys.except(:id, :created_at, :updated_at)

        expect(record_attributes).to eql(updated_attributes)
      end

      context 'without any change' do
        it 'does not update record' do
          time = 30.minutes.ago

          Timecop.freeze(time) do
            described_class.import_from(attributes)
          end

          described_class.import_from(attributes)

          record = described_class.find_by(uri: attributes[:uri])
          record_attributes = record.attributes.symbolize_keys.except(:id, :created_at, :updated_at)

          expect(record.updated_at.change(usec: 0)).to eq(time.change(usec: 0))
          expect(record_attributes).to eq(attributes)
        end
      end

      context 'when restricted attributes for update changes' do
        it 'does not update record' do
          time = 30.minutes.ago

          Timecop.freeze(time) do
            described_class.import_from(attributes)
          end

          restricted_attributes = described_class.importable_restricted_attributes_for_update.inject(Hash.new) do |hash, attribute|
            hash[attribute] = rand.to_s

            hash
          end

          described_class.import_from(attributes.merge(restricted_attributes))

          record = described_class.find_by(uri: attributes[:uri])
          record_attributes = record.attributes.symbolize_keys.except(:id, :created_at, :updated_at)

          expect(record.updated_at.change(usec: 0)).to eq(time.change(usec: 0))
          expect(record_attributes).to eq(attributes)
        end
      end
    end
  end
end
