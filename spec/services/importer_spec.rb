require 'rails_helper'

RSpec.describe Importer do
  describe '.import_or_update' do
    let(:attributes) { { name: 'Peter', surname: 'Parker' } }
    let(:record) { double(:record, attributes: attributes) }

    context 'when attributes change' do
      let(:updated_attributes) { { name: 'Peter', surname: 'Pan' } }

      it 'updates record' do
        expect(record).to receive(:attributes=).with(updated_attributes)
        expect(record).to receive(:save!)

        Importer.import_or_update(record, attributes: updated_attributes)
      end
    end

    context 'when attributes do not change' do
      it 'does not update record' do
        expect(record).not_to receive(:attributes=)
        expect(record).not_to receive(:save!)

        expect(Importer.import_or_update(record, attributes: attributes)).to be_nil
      end
    end

    context 'when restricted attributes change' do
      let(:restricted_attributes) { [:name] }
      let(:updated_attributes) { { name: 'John', surname: 'Parker' } }

      it 'does not update record' do
        expect(record).not_to receive(:attributes=).with(updated_attributes)
        expect(record).not_to receive(:save!)

        Importer.import_or_update(record, attributes: updated_attributes, restricted_attributes: restricted_attributes)
      end
    end
  end
end
