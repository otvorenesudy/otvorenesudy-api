require 'rails_helper'

RSpec.describe DecreeReconciler do
  subject { DecreeReconciler.new(decree, mapper: mapper) }

  let(:decree) { double(:decree) }
  let(:mapper) { double(:mapper, attributes) }
  let(:attributes) do
    {
      uri: 'uri',
      ecli: 'ecli',
      case_number: '1234/456/789',
      file_number: '123456789',
      date: Time.now,
      form: 'form',
      form_code: 'code',
      court: 'Court #1',
      legislation_areas: ['Legislation Area #1'],
      legislation_subareas: ['Legislation Subarea #1'],
      judges: ['Peter Pan', 'Peter Smith'],
      natures: ['Decree Nature #1'],
      pages: ['Fulltext #1', 'Fulltext #2'],
      pdf_uri: 'http://uri.pdf'
    }
  end

  describe '#reconcile!' do
    it 'reconciles decree from mapper' do
      expect(decree).to receive(:with_lock).and_yield.ordered

      expect(subject).to receive(:reconcile_attributes)
      expect(subject).to receive(:reconcile_court)
      expect(subject).to receive(:reconcile_legislation_areas)
      expect(subject).to receive(:reconcile_legislation_subareas)
      expect(subject).to receive(:reconcile_proceeding)
      expect(subject).to receive(:reconcile_judges)
      expect(subject).to receive(:reconcile_natures)
      expect(subject).to receive(:reconcile_legislations)
      expect(subject).to receive(:reconcile_pages)

      expect(decree).to receive(:save!).ordered
      expect(decree).to receive(:touch).ordered

      subject.reconcile!
    end
  end

  describe '#reconcile_attributes' do
    it 'reconciles attributes for decree' do
      allow(Source).to receive(:find_by!).with(module: 'JusticeGovSk') { :source }
      allow(Decree::Form).to receive(:find_by!).with(value: 'form', code: 'code') { :form }

      expect(decree).to receive(:update!).with(
        source: :source,
        uri: 'uri',
        ecli: 'ecli',
        case_number: '1234/456/789',
        file_number: '123456789',
        date: mapper.date,
        form: :form,
        pdf_uri: 'http://uri.pdf'
      )

      subject.reconcile_attributes
    end
  end

  describe '#reconcile_court' do
    it 'reconciles court' do
      allow(Court).to receive(:find_by!).with(name: 'Court #1') { :court }
      expect(decree).to receive(:court=).with(:court)

      subject.reconcile_court
    end

    context 'when court is not present' do
      let(:attributes) { { court: nil } }

      it 'does not try to find court' do
        expect(Court).not_to receive(:find_by!)

        subject.reconcile_court
      end
    end
  end

  describe '#reconcile_legislation_areas' do
    it 'reconciles legislation areas' do
      allow(Legislation::Area).to receive(:find_or_create_by!).with(value: 'Legislation Area #1') { :legislation_area }
      expect(Legislation::AreaUsage).to receive(:find_or_create_by!).with(decree: decree, area: :legislation_area)

      subject.reconcile_legislation_areas
    end

    context 'when legislation area is not present' do
      let(:attributes) { { legislation_areas: nil } }

      it 'does not reconcile legislation area' do
        expect(Legislation::AreaUsage).not_to receive(:find_or_create_by!)

        subject.reconcile_legislation_areas
      end
    end
  end

  describe '#reconcile_legislation_subareas' do
    it 'reconciles legislation subarea with legislation area' do
      allow(Legislation::Subarea).to receive(:find_or_create_by!).with(value: 'Legislation Subarea #1') {
        :legislation_subarea
      }
      expect(Legislation::SubareaUsage).to receive(:find_or_create_by!).with(decree: decree, subarea: :legislation_subarea)

      subject.reconcile_legislation_subareas
    end

    context 'when legislation area is not present' do
      let(:attributes) { { legislation_areas: nil } }

      it 'does not reconcile legislation area' do
        expect(Legislation::SubareaUsage).not_to receive(:find_or_create_by!)

        subject.reconcile_legislation_areas
      end
    end

    context 'when legislation subarea is not present' do
      let(:attributes) { { legislation_areas: ['Legislation Area #1'], legislation_subareas: nil } }

      it 'does not reconcile legislation area' do
        expect(Legislation::SubareaUsage).not_to receive(:find_or_create_by!)

        subject.reconcile_legislation_subareas
      end
    end
  end

  describe '#reconcile_judges' do
    it 'reconciles judges for decree' do
      judgements = [double(:judgement), double(:judgement)]

      allow(JudgeFinder).to receive(:find_by).with(name: 'Peter Pan') { :judge }
      allow(JudgeFinder).to receive(:find_by).with(name: 'Peter Smith') { nil }

      allow(Judgement).to receive(:find_or_initialize_by).with(decree: decree, judge: :judge) { judgements[0] }
      allow(Judgement).to receive(:find_or_initialize_by).with(decree: decree, judge_name_unprocessed: 'Peter Smith') {
        judgements[1]
      }

      expect(judgements[0]).to receive(:update!).with(
        judge: :judge,
        judge_name_similarity: 1,
        judge_name_unprocessed: 'Peter Pan'
      )
      expect(judgements[1]).to receive(:update!).with(
        judge: nil,
        judge_name_similarity: 0,
        judge_name_unprocessed: 'Peter Smith'
      )

      expect(decree).to receive(:purge!).with(:judgements, except: judgements)

      subject.reconcile_judges
    end
  end

  describe '#reconcile_natures' do
    it 'reconciles natures' do
      naturalization = double(:naturalization)

      allow(Decree::Nature).to receive(:find_or_create_by!).with(value: 'Decree Nature #1') { :nature }
      expect(Decree::Naturalization).to receive(:find_or_create_by!).with(decree: decree, nature: :nature) {
        naturalization
      }
      expect(decree).to receive(:purge!).with(:naturalizations, except: [naturalization])

      subject.reconcile_natures
    end
  end

  describe '#reconcile_pages' do
    it 'reconciles pages from fulltext already extracted in dataset' do
      pages = [double(:page_1), double(:page_2)]

      allow(Decree::Page).to receive(:find_or_initialize_by).with(decree: decree, number: 1) { pages[0] }
      allow(Decree::Page).to receive(:find_or_initialize_by).with(decree: decree, number: 2) { pages[1] }

      expect(pages[0]).to receive(:update!).with(text: 'Fulltext #1')
      expect(pages[1]).to receive(:update!).with(text: 'Fulltext #2')
      expect(decree).to receive(:purge!).with(:pages, except: pages)

      subject.reconcile_pages
    end
  end
end
