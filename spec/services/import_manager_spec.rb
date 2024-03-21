require 'spec_helper'
require 'active_support/all'
require_relative '../../app/services/import_manager'

RSpec.describe ImportManager do
  let(:record) { double(:record, attributes: { name: 'Peter', surname: 'Smith' }) }
  let(:attributes) { { name: 'Peter', surname: 'Parker' } }

  describe '.import_or_update' do
    context 'when attributes change' do
      it 'updates record with attributes' do
        expect(record).to receive(:update!).with(attributes)

        ImportManager.import_or_update(record, attributes: attributes)
      end
    end

    context 'without change' do
      let(:attributes) { { name: 'Peter', surname: 'Smith' } }

      it 'does not dispatch update for attributes' do
        expect(record).not_to receive(:update!)

        ImportManager.import_or_update(record, attributes: attributes)
      end
    end

    context 'when restricted attributes for update changes' do
      it 'does not update record' do
        expect(record).not_to receive(:update!)

        ImportManager.import_or_update(record, attributes: attributes, restricted_attributes_for_update: [:surname])
      end
    end
  end
end
