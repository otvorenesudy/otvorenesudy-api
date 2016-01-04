require 'spec_helper'
require 'active_support/all'
require_relative '../../app/services/update_delegator'

RSpec.describe UpdateDelegator do
  subject { UpdateDelegator.new(record) }

  let(:record) { double(:record, attributes: attributes) }
  let(:attributes) { { a: 1, b: 2 } }

  it 'delegates #update_attributes method to record' do
    expect(record).to receive(:update_attributes!).with(attributes)

    subject.update_attributes!(attributes)
  end

  describe '#attributes=' do
    it 'assigns and reconciles attributes keys to symbols' do
      subject.attributes = { a: 1, 'b' => 2, c: { 'd' => 3 } }

      expect(subject.attributes).to eql(a: 1, b: 2, c: { d: 3 })
    end
  end

  describe '#changed?' do
    context 'when attributes are not set' do
      it 'raises an error' do
        expect {
          subject.changed?
        }.to raise_error(ArgumentError, 'You need to provide attributes to compare with first.')
      end
    end

    context 'when attributes did not changed' do
      it 'does not report change' do
        subject.attributes = attributes

        expect(subject.changed?).to be_falsey
      end
    end

    context 'when attributes changed' do
      it 'reports change' do
        subject.attributes = attributes.merge(b: 3)

        expect(subject.changed?).to be_truthy
      end
    end

    context 'when attributes change in depth' do
      let(:attributes) {
        {
          a: 1,
          b: 2,
          c: {
            d: 3
          }
        }
      }

      it 'reports change as well' do
        subject.attributes = attributes.merge(c: { d: 4 })

        expect(subject.changed?).to be_truthy
      end
    end

    context 'when only restricted attributes change' do
      subject { UpdateDelegator.new(record, restricted_attributes: [:a]) }

      it 'does not report change' do
        subject.attributes = attributes.merge(a: 2)

        expect(subject.changed?).to be_falsey
      end
    end
  end
end
