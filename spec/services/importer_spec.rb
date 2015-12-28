require 'rails_helper'

RSpec.describe Importer do
  let(:attributes) { { name: 'Peter', surname: 'Parker' } }
  let(:dispatcher) { double(:dispatcher) }

  describe '.import_or_update' do
    context 'when attributes change' do
      it 'dispatches update for attributes' do
        expect(dispatcher).to receive(:attributes=).with(attributes)
        allow(dispatcher).to receive(:changed?) { true }
        expect(dispatcher).to receive(:update_attributes!).with(attributes)

        Importer.import_or_update(dispatcher, attributes: attributes)
      end
    end

    context 'without change' do
      it 'does not dispatch update for attributes' do
        expect(dispatcher).to receive(:attributes=).with(attributes)
        allow(dispatcher).to receive(:changed?) { false }
        expect(dispatcher).not_to receive(:update_attributes!)

        Importer.import_or_update(dispatcher, attributes: attributes)
      end
    end
  end
end
