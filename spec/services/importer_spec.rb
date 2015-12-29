require 'rails_helper'

RSpec.describe Importer do
  let(:attributes) { { name: 'Peter', surname: 'Parker' } }
  let(:delegator) { double(:delegator) }

  describe '.import_or_update' do
    context 'when attributes change' do
      it 'dispatches update for attributes' do
        expect(delegator).to receive(:attributes=).with(attributes)
        allow(delegator).to receive(:changed?) { true }
        expect(delegator).to receive(:update_attributes!).with(attributes)

        Importer.import_or_update(delegator, attributes: attributes)
      end
    end

    context 'without change' do
      it 'does not dispatch update for attributes' do
        expect(delegator).to receive(:attributes=).with(attributes)
        allow(delegator).to receive(:changed?) { false }
        expect(delegator).not_to receive(:update_attributes!)

        Importer.import_or_update(delegator, attributes: attributes)
      end
    end
  end
end
