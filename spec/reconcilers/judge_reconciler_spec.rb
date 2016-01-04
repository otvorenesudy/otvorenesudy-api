require 'rails_helper'

RSpec.describe JudgeReconciler do
  subject { JudgeReconciler.new(judge, mapper: mapper) }

  let(:mapper) { double(:mapper, attributes) }
  let(:judge) { double(:judge, employments: employments) }
  let(:employments) { double(:employments) }

  let(:attributes) {
    {
      uri: 'uri',
      partitioned_name: {
        value: 'JUDr. Peter Parker, PhD.',
        unprocessed: 'JUDr. Peter PARKER, Phd.',
        prefix: 'JUDr.',
        first: 'Peter',
        middle: nil,
        last: 'Parker',
        suffix: 'PhD.',
        addition: nil
      },

      court: 'Krajský súd Trenčín',
      position: 'predseda',
      temporary_court: 'Okresný súd Prievidza',
      active: true,
      note: 'note'
    }
  }

  describe '#reconcile!' do
    it 'reconciles and saves judge' do
      expect(subject).to receive(:reconcile_attributes).ordered
      expect(subject).to receive(:reconcile_past_employments).ordered
      expect(subject).to receive(:reconcile_employment).ordered
      expect(subject).to receive(:reconcile_temporary_employment).ordered

      expect(judge).to receive(:save!)
      expect(judge).to receive(:touch)

      subject.reconcile!
    end
  end

  describe '#reconcile_attributes' do
    it 'reconciles attributes for judge' do
      allow(Source).to receive(:find_by).with(module: 'JusticeGovSk') { :source }

      expect(judge).to receive(:update_attributes!).with(
        uri: 'uri',
        source: :source,
        name: 'JUDr. Peter Parker, PhD.',
        name_unprocessed: 'JUDr. Peter PARKER, Phd.',
        prefix: 'JUDr.',
        first: 'Peter',
        middle: nil,
        last: 'Parker',
        suffix: 'PhD.',
        addition: nil
      )

      subject.reconcile_attributes
    end
  end

  describe '#reconcile_past_employment' do
    it 'sets past employement as inactive' do
      expect(employments).to receive(:update_all).with(active: false)

      subject.reconcile_past_employments
    end
  end


  describe '#reconcile_employment' do
    let(:employment) { double(:employment) }

    it 'reconciles employement' do
      allow(Judge::Position).to receive(:find_or_create_by!).with(value: 'predseda') { :position }
      allow(Court).to receive(:find_by).with(name: 'Krajský súd Trenčín') { :court }
      allow(employments).to receive(:find_or_initialize_by).with(court: :court) { employment }

      expect(employment).to receive(:update_attributes!).with(
        position: :position,
        active: true,
        note: 'note'
      )

      subject.reconcile_employment
    end
  end

  describe '#reconcile_temporary_employment' do
    let(:employment) { double(:employment) }

    it 'reconciles temporary employment' do
      allow(Judge::Position).to receive(:find_or_create_by!).with(value: 'sudca') { :position }
      allow(Court).to receive(:find_by).with(name: 'Okresný súd Prievidza') { :court }
      allow(employments).to receive(:find_or_initialize_by).with(court: :court) { employment }

      expect(employment).to receive(:update_attributes!).with(
        position: :position,
        active: true
      )

      subject.reconcile_temporary_employment
    end

    context 'when temporary court is not set' do
      let(:attributes) { { temporary_court: nil } }

      it 'does not reconcile temporary employement' do
        expect(Judge::Position).not_to receive(:find_or_create_by!)
        expect(Court).not_to receive(:find_by)
        expect(employments).not_to receive(:find_or_initialize_by)

        subject.reconcile_temporary_employment
      end
    end
  end
end
