require 'rails_helper'

RSpec.describe JudgeReconciler do
  subject { JudgeReconciler.new(judge, mapper: mapper) }

  let(:mapper) { double(:mapper, attributes) }
  let(:judge) { double(:judge, employments: employments) }
  let(:employments) { double(:employments) }

  let(:attributes) do
    {
      uri: 'uri',
      source: 'JusticeGovSk',
      source_class: 'ObcanJusticeSk::Judge',
      source_class_id: '123',
      name: {
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
      status: :active,
      note: 'note'
    }
  end

  describe '#reconcile!' do
    it 'reconciles and saves judge' do
      expect(judge).to receive(:with_lock).and_yield

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
      allow(Source).to receive(:find_by!).with(module: 'JusticeGovSk') { :source }

      expect(judge).to receive(:update!).with(
        uri: 'uri',
        source: :source,
        source_class: 'ObcanJusticeSk::Judge',
        source_class_id: '123',
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
      allow(Court).to receive(:find_by!).with(name: 'Krajský súd Trenčín') { :court }
      allow(employments).to receive(:find_or_initialize_by).with(court: :court) { employment }

      expect(employment).to receive(:update!).with(position: :position, active: true, status: :active, note: 'note')

      subject.reconcile_employment
    end
  end

  describe '#reconcile_temporary_employment' do
    let(:employment) { double(:employment) }

    it 'reconciles temporary employment' do
      allow(Judge::Position).to receive(:find_or_create_by!).with(value: 'sudca') { :position }
      allow(Court).to receive(:find_by!).with(name: 'Okresný súd Prievidza') { :court }
      allow(employments).to receive(:find_or_initialize_by).with(court: :court) { employment }

      expect(employment).to receive(:update!).with(position: :position, active: true)

      subject.reconcile_temporary_employment
    end

    context 'when temporary court is not set' do
      let(:attributes) { { temporary_court: nil } }

      it 'does not reconcile temporary employement' do
        expect(Judge::Position).not_to receive(:find_or_create_by!)
        expect(Court).not_to receive(:find_by!)
        expect(employments).not_to receive(:find_or_initialize_by)

        subject.reconcile_temporary_employment
      end
    end
  end

  describe '#reconcile_as_judicial_council_chairman' do
    context 'when judge is a chairman of judicial council' do
      let(:attributes) { { judicial_council_chairman_court_names: ['Krajský súd Trenčín'] } }
      let(:employment) { double(:employment) }

      it 'reconciles employement as judicial council chairman' do
        allow(Judge::Position).to receive(:find_or_create_by!).with(value: 'predseda súdnej rady') { :position }
        allow(Court).to receive(:find_by!).with(name: 'Krajský súd Trenčín') { :court }
        allow(employments).to receive(:find_or_initialize_by).with(court: :court) { employment }

        expect(employment).to receive(:update!).with(position: :position, active: true)

        subject.reconcile_as_judicial_council_chairman
      end
    end

    context 'when judge is not a chairman of any judicial council' do
      let(:attributes) { { judicial_council_chairman_court_names: [] } }

      it 'does not reconcile employement as judicial council chairman' do
        expect(Judge::Position).not_to receive(:find_or_create_by!)
        expect(Court).not_to receive(:find_by!)
        expect(employments).not_to receive(:find_or_initialize_by)

        subject.reconcile_as_judicial_council_chairman
      end
    end

    context 'when judicial council chairman court names are not set' do
      it 'does not reconcile employement as judicial council chairman' do
        expect(Judge::Position).not_to receive(:find_or_create_by!)
        expect(Court).not_to receive(:find_by!)
        expect(employments).not_to receive(:find_or_initialize_by)

        subject.reconcile_as_judicial_council_chairman
      end
    end
  end

  describe '#reconcile_as_judicial_council_member' do
    context 'when judge is a member of judicial council' do
      let(:attributes) { { judicial_council_member_court_names: ['Krajský súd Trenčín'] } }
      let(:employment) { double(:employment) }

      it 'reconciles employement as judicial council chairman' do
        allow(Judge::Position).to receive(:find_or_create_by!).with(value: 'člen súdnej rady') { :position }
        allow(Court).to receive(:find_by!).with(name: 'Krajský súd Trenčín') { :court }
        allow(employments).to receive(:find_or_initialize_by).with(court: :court) { employment }

        expect(employment).to receive(:update!).with(position: :position, active: true)

        subject.reconcile_as_judicial_council_member
      end
    end

    context 'when judge is not a member of any judicial council' do
      let(:attributes) { { judicial_council_member_court_names: [] } }

      it 'does not reconcile employement as judicial council member' do
        expect(Judge::Position).not_to receive(:find_or_create_by!)
        expect(Court).not_to receive(:find_by!)
        expect(employments).not_to receive(:find_or_initialize_by)

        subject.reconcile_as_judicial_council_member
      end
    end

    context 'when judicial council member court names are not set' do
      it 'does not reconcile employement as judicial council member' do
        expect(Judge::Position).not_to receive(:find_or_create_by!)
        expect(Court).not_to receive(:find_by!)
        expect(employments).not_to receive(:find_or_initialize_by)

        subject.reconcile_as_judicial_council_member
      end
    end
  end
end
