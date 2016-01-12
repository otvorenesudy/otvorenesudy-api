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
      judges: [
        { value: 'JUDr. Peter Pan', unprocessed: 'JuDR Peter Pan' }
      ],
      chair_judges: [
        { value: 'JUDr. Peter Parker', unprocessed: 'JUDR Peter Parker' }
      ],
      opponents: ['Peter Pan', 'John Smith'],
      defendants: ['John Pan'],
      proposers: ['John Smithy']
    }
  }

  describe '#reconcile_attributes' do
    it 'reconciles attributes' do
      allow(Source).to receive(:find_by).with(module: 'JusticeGovSk') { source }
      allow(Hearing::Type).to receive(:find_or_create_by!).with(value: 'Trestné') { :type }

      expect(hearing).to receive(:update_attributes!).with(
        attributes.slice(:uri, :case_number, :file_number, :date, :room, :selfjudge, :note, :special_type).merge(type: :type, source: source)
      )

      subject.reconcile_attributes
    end
  end

  describe '#reconcile_court' do
    it 'reconciles court' do
      allow(Court).to receive(:find_by).with(name: 'Krajský súd Bratislava I') { :court }
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
      allow(JudgeFinder).to receive(:find_by).with(name: 'JUDr. Peter Pan') { :judge_1 }
      allow(JudgeFinder).to receive(:find_by).with(name: 'JUDr. Peter Parker') { :judge_2 }

      expect(Judging).to receive(:find_or_create_by!).with(
        judge: :judge_2,
        hearing: hearing,
        judge_name_unprocessed: 'JUDR Peter Parker',
        judge_name_similarity: 1,
        judge_chair: true
      ).and_return(:judging_1)

      expect(Judging).to receive(:find_or_create_by!).with(
        judge: :judge_1,
        hearing: hearing,
        judge_name_unprocessed: 'JuDR Peter Pan',
        judge_name_similarity: 1,
        judge_chair: false
      ).and_return(:judging_2)

      expect(hearing).to receive(:purge!).with(:judgings, except: [:judging_1, :judging_2])

      subject.reconcile_judges
    end

    context 'when judge does not exist' do
      it 'provides only unprocessed name' do
        allow(JudgeFinder).to receive(:find_by).with(name: 'JUDr. Peter Pan') { nil }
        allow(JudgeFinder).to receive(:find_by).with(name: 'JUDr. Peter Parker') { :judge_2 }

        expect(Judging).to receive(:find_or_create_by!).with(
          judge: :judge_2,
          hearing: hearing,
          judge_name_unprocessed: 'JUDR Peter Parker',
          judge_name_similarity: 1,
          judge_chair: true
        )

        expect(Judging).to receive(:find_or_create_by!).with(
          judge: nil,
          hearing: hearing,
          judge_name_unprocessed: 'JuDR Peter Pan',
          judge_name_similarity: 0,
          judge_chair: false
        )

        expect(hearing).to receive(:purge!)

        subject.reconcile_judges
      end
    end
  end

  describe '#reconcile_opponents' do
    it 'reconciles opponents' do
      expect(Opponent).to receive(:find_or_create_by!).with(name: 'Peter Pan', name_unprocessed: 'Peter Pan', hearing: hearing).and_return(:opponent_1)
      expect(Opponent).to receive(:find_or_create_by!).with(name: 'John Smith', name_unprocessed: 'John Smith', hearing: hearing).and_return(:opponent_2)

      expect(hearing).to receive(:purge!).with(:opponents, except: [:opponent_1, :opponent_2])

      subject.reconcile_opponents
    end
  end

  describe '#reconcile_defendants' do
    it 'reconciles defendants' do
      expect(Defendant).to receive(:find_or_create_by!).with(name: 'John Pan', name_unprocessed: 'John Pan', hearing: hearing).and_return(:defendant_1)

      expect(hearing).to receive(:purge!).with(:defendants, except: [:defendant_1])

      subject.reconcile_defendants
    end
  end

  describe '#reconcile_proposers' do
    it 'reconciles proposers' do
      expect(Proposer).to receive(:find_or_create_by!).with(name: 'John Smithy', name_unprocessed: 'John Smithy', hearing: hearing).and_return(:proposer_1)

      expect(hearing).to receive(:purge!).with(:proposers, except: [:proposer_1])

      subject.reconcile_proposers
    end
  end
end