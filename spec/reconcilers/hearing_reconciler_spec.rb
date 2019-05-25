require 'rails_helper'

RSpec.describe HearingReconciler do
  subject { HearingReconciler.new(hearing, mapper: mapper) }

  let(:hearing) { double(:hearing) }
  let(:mapper) { double(:mapper, attributes) }
  let(:source) { double(:source) }
  let(:attributes) {
    {
      uri: 'http://path/to/hearing',
      case_number: '12/23/12CS',
      file_number: '12345678',
      date: Time.now,
      room: 'Miestnost 123',
      selfjudge: true,
      note: nil,
      special_type: nil,
      court: 'Krajský súd Bratislava I',
      type: 'Trestné',
      section: 'Civilný',
      subject: 'Zaplatenie pokuty - 33 eur',
      form: 'Verejné zasadnutie',
      judges: ['JUDr. Peter Pan'],
      chair_judges: ['JUDr. Peter Parker'],
      opponents: ['Peter Pan', 'John Smith'],
      defendants: ['John Pan'],
      proposers: ['John Smithy']
    }
  }

  before :each do
    allow(HearingReconciler::RandomInitialsProvider).to receive(:provide) {
      'A. B.'
    }
  end

  describe '#reconcile_attributes' do
    it 'reconciles attributes' do
      allow(Source).to receive(:find_by!).with(module: 'JusticeGovSk') { source }
      allow(Hearing::Type).to receive(:find_by!).with(value: 'Trestné') { :type }

      expect(hearing).to receive(:update_attributes!).with(
        attributes.slice(:uri, :case_number, :file_number, :date, :room, :selfjudge, :note, :special_type).merge(type: :type, source: source)
      )

      subject.reconcile_attributes
    end
  end

  describe '#reconcile_court' do
    it 'reconciles court' do
      allow(Court).to receive(:find_by!).with(name: 'Krajský súd Bratislava I') { :court }
      expect(hearing).to receive(:court=).with(:court)

      subject.reconcile_court
    end
  end

  describe '#reconcile_section' do
    it 'reconciles hearing section' do
      allow(Hearing::Section).to receive(:find_or_create_by!).with(value: 'Civilný') { :section }
      expect(hearing).to receive(:section=).with(:section)

      subject.reconcile_section
    end
  end

  describe '#reconcile_subject' do
    it 'reconciles hearing subject' do
      allow(Hearing::Subject).to receive(:find_or_create_by!).with(value: 'Zaplatenie pokuty - 33 eur') { :subject }
      expect(hearing).to receive(:subject=).with(:subject)

      subject.reconcile_subject
    end
  end

  describe '#reconcile_form' do
    it 'reconciles hearing form' do
      allow(Hearing::Form).to receive(:find_or_create_by!).with(value: 'Verejné zasadnutie') { :form }
      expect(hearing).to receive(:form=).with(:form)

      subject.reconcile_form
    end
  end

  describe '#reconcile_proceeding' do
    it 'reconciles proceeding for hearing by file number' do
      allow(Proceeding).to receive(:find_or_create_by!).with(file_number: '12345678') { :proceeding }
      expect(hearing).to receive(:proceeding=).with(:proceeding)

      subject.reconcile_proceeding
    end
  end

  describe '#reconcile_judges' do
    it 'reconciles existing judges' do
      allow(JudgeFinder).to receive(:find_by).with(name: 'JUDr. Peter Parker') { :judge_1 }
      allow(JudgeFinder).to receive(:find_by).with(name: 'JUDr. Peter Pan') { :judge_2 }

      judgings = [double(:judging), double(:judging)]

      expect(Judging).to receive(:find_or_initialize_by).with(
        judge: :judge_1,
        hearing: hearing
      ).and_return(judgings[0])

      expect(Judging).to receive(:find_or_initialize_by).with(
        judge: :judge_2,
        hearing: hearing
      ).and_return(judgings[1])

      expect(judgings[0]).to receive(:update_attributes!).with(
        judge: :judge_1,
        judge_name_unprocessed: 'JUDr. Peter Parker',
        judge_name_similarity: 1,
        judge_chair: true
      )

      expect(judgings[1]).to receive(:update_attributes!).with(
        judge: :judge_2,
        judge_name_unprocessed: 'JUDr. Peter Pan',
        judge_name_similarity: 1,
        judge_chair: false
      )

      expect(hearing).to receive(:purge!).with(:judgings, except: judgings)

      subject.reconcile_judges
    end

    context 'when judge does not exist' do
      it 'provides only unprocessed name' do
        allow(JudgeFinder).to receive(:find_by).with(name: 'JUDr. Peter Pan') { nil }
        allow(JudgeFinder).to receive(:find_by).with(name: 'JUDr. Peter Parker') { :judge_2 }

        expect(Judging).to receive(:find_or_initialize_by).with(
          judge: :judge_2,
          hearing: hearing,
        ).and_return(double.as_null_object)

        expect(Judging).to receive(:find_or_initialize_by).with(
          judge_name_unprocessed: 'JUDr. Peter Pan',
          hearing: hearing,
        ).and_return(double.as_null_object)

        expect(hearing).to receive(:purge!)

        subject.reconcile_judges
      end
    end
  end

  describe '#reconcile_opponents' do
    it 'reconciles opponents' do
      opponents = [double(:opponent), double(:opponent)]

      expect(Opponent).to receive(:find_or_initialize_by).with(name_unprocessed: 'Peter Pan', hearing: hearing).and_return(opponents[0])
      expect(Opponent).to receive(:find_or_initialize_by).with(name_unprocessed: 'John Smith', hearing: hearing).and_return(opponents[1])

      expect(opponents[0]).to receive(:update_attributes!).with(name: 'A. B.')
      expect(opponents[1]).to receive(:update_attributes!).with(name: 'A. B.')

      expect(hearing).to receive(:purge!).with(:opponents, except: opponents)

      subject.reconcile_opponents
    end
  end

  describe '#reconcile_defendants' do
    it 'reconciles defendants' do
      defendant = double(:defendant)

      expect(Defendant).to receive(:find_or_initialize_by).with(name_unprocessed: 'John Pan', hearing: hearing).and_return(defendant)
      expect(defendant).to receive(:update_attributes!).with(name: 'A. B.')
      expect(hearing).to receive(:purge!).with(:defendants, except: [defendant])

      subject.reconcile_defendants
    end
  end

  describe '#reconcile_proposers' do
    it 'reconciles proposers' do
      proposer = double(:proposer)

      expect(Proposer).to receive(:find_or_initialize_by).with(name_unprocessed: 'John Smithy', hearing: hearing).and_return(proposer)
      expect(proposer).to receive(:update_attributes!).with(name: 'A. B.')
      expect(hearing).to receive(:purge!).with(:proposers, except: [proposer])

      subject.reconcile_proposers
    end
  end
end

RSpec.describe HearingReconciler::RandomInitialsProvider do
  describe '#provide' do
    it 'provides random initials' do
      expect(described_class.provide.join(' ')).to match(/\A[A-Z] [A-Z]\z/)
    end
  end
end
