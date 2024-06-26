require 'rails_helper'

RSpec.describe HearingReconciler do
  subject { HearingReconciler.new(hearing, mapper: mapper) }

  let(:hearing) { double(:hearing) }
  let(:mapper) { double(:mapper, attributes) }
  let(:source) { double(:source) }
  let(:attributes) do
    {
      uri: 'http://path/to/hearing',
      source: 'JusticeGovSk',
      source_class: 'ObcanJusticeSk::CivilHearing',
      source_class_id: 1,
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
      judges: [double(:judge, name: 'JUDr. Peter Pan')],
      chair_judges: [double(:judge, name: 'JUDr. Peter Parker')],
      opponents: ['Peter Pan', 'John Smith'],
      defendants: ['John Pan'],
      proposers: ['John Smithy'],
      original_court: 'Krajský súd Bratislava II',
      original_case_number: '12/23/12CS'
    }
  end

  before :each do
    allow(HearingReconciler::RandomInitialsProvider).to receive(:provide) { 'A. B.' }
  end

  describe '#reconcile_attributes' do
    it 'reconciles attributes' do
      Timecop.freeze do
        allow(Source).to receive(:find_by!).with(module: 'JusticeGovSk') { source }
        allow(Hearing::Type).to receive(:find_by!).with(value: 'Trestné') { :type }

        expect(hearing).to receive(:update!).with(
          attributes.slice(
            :uri,
            :source_class,
            :source_class_id,
            :case_number,
            :file_number,
            :date,
            :room,
            :selfjudge,
            :note,
            :special_type,
            :original_case_number
          ).merge(type: :type, source: source, anonymized_at: Time.now)
        )

        subject.reconcile_attributes
      end
    end
  end

  describe '#reconcile_court' do
    it 'reconciles court' do
      allow(Court).to receive(:find_by!).twice.with(name: 'Krajský súd Bratislava I') { :court_1 }
      allow(Court).to receive(:find_by!).twice.with(name: 'Krajský súd Bratislava II') { :court_2 }
      expect(hearing).to receive(:court=).with(:court_1)
      expect(hearing).to receive(:original_court=).with(:court_2)

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
      judgings = [double(:judging), double(:judging)]

      expect(Judging).to receive(:find_or_initialize_by).with(
        judge: attributes[:chair_judges][0],
        hearing: hearing
      ).and_return(judgings[0])

      expect(Judging).to receive(:find_or_initialize_by).with(
        judge: attributes[:judges][0],
        hearing: hearing
      ).and_return(judgings[1])

      expect(judgings[0]).to receive(:update!).with(judge_chair: true, judge_name_similarity: 1)
      expect(judgings[1]).to receive(:update!).with(judge_chair: false, judge_name_similarity: 1)

      expect(hearing).to receive(:purge!).with(:judgings, except: judgings)

      subject.reconcile_judges
    end
  end

  describe '#reconcile_opponents' do
    it 'reconciles opponents' do
      opponents = [double(:opponent), double(:opponent)]

      expect(Opponent).to receive(:find_or_initialize_by).with(
        name_unprocessed: 'Peter Pan',
        hearing: hearing
      ).and_return(opponents[0])
      expect(Opponent).to receive(:find_or_initialize_by).with(
        name_unprocessed: 'John Smith',
        hearing: hearing
      ).and_return(opponents[1])

      expect(opponents[0]).to receive(:update!).with(name: 'A. B.')
      expect(opponents[1]).to receive(:update!).with(name: 'A. B.')

      expect(hearing).to receive(:purge!).with(:opponents, except: opponents)

      subject.reconcile_opponents
    end
  end

  describe '#reconcile_defendants' do
    it 'reconciles defendants' do
      defendant = double(:defendant)

      expect(Defendant).to receive(:find_or_initialize_by).with(
        name_unprocessed: 'John Pan',
        hearing: hearing
      ).and_return(defendant)
      expect(defendant).to receive(:update!).with(name: 'A. B.')
      expect(hearing).to receive(:purge!).with(:defendants, except: [defendant])

      subject.reconcile_defendants
    end
  end

  describe '#reconcile_proposers' do
    it 'reconciles proposers' do
      proposer = double(:proposer)

      expect(Proposer).to receive(:find_or_initialize_by).with(
        name_unprocessed: 'John Smithy',
        hearing: hearing
      ).and_return(proposer)
      expect(proposer).to receive(:update!).with(name: 'A. B.')
      expect(hearing).to receive(:purge!).with(:proposers, except: [proposer])

      subject.reconcile_proposers
    end
  end
end

RSpec.describe HearingReconciler::RandomInitialsProvider do
  describe '#provide' do
    it 'provides random initials' do
      expect(described_class.provide).to match(/\A[A-Z]. [A-Z].\z/)
    end
  end
end
