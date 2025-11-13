require 'spec_helper'
require 'obcan_justice_sk'
require_relative '../../../app/mappers/obcan_justice_sk/civil_hearing_mapper'
require_relative '../../../app/services/obcan_justice_sk/judge_finder'

RSpec.describe ObcanJusticeSk::CivilHearingMapper do
  subject do
    described_class.new(double(:civil_hearing, id: 1, class: double(:class, name: 'CivilHearing'), data: data))
  end

  let(:data) { JSON.parse(fixture('obcan_justice_sk/mappers/civil_hearing.json').read) }

  describe '#uri' do
    it 'maps uri from guid' do
      expect(subject.uri).to eql(
        'https://www.justice.gov.sk/sudy-a-rozhodnutia/sudy/pojednavania/f5c7b3ce-e9d6-44ed-adca-66b57190e542'
      )
    end
  end

  describe '#source' do
    it 'maps source' do
      expect(subject.source).to eql('JusticeGovSk')
    end
  end

  describe '#source_class' do
    it 'maps source class' do
      expect(subject.source_class).to eql('CivilHearing')
    end
  end

  describe '#source_class_id' do
    it 'maps source class id' do
      expect(subject.source_class_id).to eql(1)
    end
  end

  describe '#type' do
    it 'maps type' do
      expect(subject.type).to eql('Civilné')
    end
  end

  describe '#judges' do
    it 'maps judges' do
      judge = double(:judge, name: 'Mgr. Denisa Slivová')

      allow(ObcanJusticeSk::JudgeFinder).to receive(:find_by).with(name: 'Mgr. Denisa Slivová', guid: nil).and_return(
        judge
      )

      expect(subject.judges).to eql([judge])
    end
  end

  describe '#court' do
    it 'maps court' do
      expect(subject.court).to eql('Správny súd Banská Bystrica')
    end
  end

  describe '#original_court' do
    it 'maps original court' do
      expect(subject.original_court).to eql(nil)
    end
  end

  describe '#case_number' do
    it 'maps case number' do
      expect(subject.case_number).to eql('ZA-31S/55/2018')
    end
  end

  describe '#original_case_number' do
    it 'maps original case number' do
      expect(subject.original_case_number).to eql(nil)
    end
  end

  describe '#file_number' do
    it 'maps file number' do
      expect(subject.file_number).to eql('5018200202')
    end
  end

  describe '#subject' do
    it 'maps subject' do
      expect(subject.subject).to eql('preskúmanie rozh. č. 100692444/2018 z 9.4.2018')
    end
  end

  describe '#section' do
    it 'maps section' do
      expect(subject.section).to eql('S')
    end
  end

  describe '#form' do
    it 'maps form' do
      expect(subject.form).to eql('Pojednávanie a rozhodnutie')
    end
  end

  describe '#room' do
    it 'maps room' do
      expect(subject.room).to eql(nil)
    end
  end

  describe '#date' do
    it 'maps date' do
      expect(subject.date).to eql(Time.parse('2019/11/13 10:20 +0100'))
    end
  end

  describe '#note' do
    it 'maps note' do
      expect(subject.note).to eql(nil)
    end
  end

  describe '#proposers' do
    it 'maps proposers' do
      expect(subject.proposers).to eql(['ABC'])
    end
  end

  describe '#opponents' do
    it 'maps opponents' do
      expect(subject.opponents).to eql(['Finančné riaditeľstvo SR, Banská Bystrica'])
    end
  end

  describe '#defendants' do
    it 'maps defendants' do
      expect(subject.defendants).to eql([])
    end
  end

  describe '#selfjudge' do
    it 'maps selfjudge' do
      expect(subject.selfjudge).to eql(nil)
    end
  end

  describe '#special_type' do
    it 'maps special type' do
      expect(subject.special_type).to eql(nil)
    end
  end

  describe '#chair_judges' do
    it 'maps chair judges' do
      expect(subject.chair_judges).to eql([])
    end
  end

  context 'with original court and case number' do
    let(:data) { JSON.parse(fixture('obcan_justice_sk/mappers/civil_hearing_with_original_court.json').read) }

    describe '#court' do
      it 'maps court' do
        expect(subject.court).to eql('Okresný súd Nitra')
      end
    end

    describe '#original_court' do
      it 'maps original court' do
        expect(subject.original_court).to eql('Okresný súd Topoľčany')
      end
    end

    describe '#case_number' do
      it 'maps case number' do
        expect(subject.case_number).to eql('TO-10P/42/2023')
      end
    end

    describe '#original_case_number' do
      it 'maps original case number' do
        expect(subject.original_case_number).to eql('10P/42/2023')
      end
    end
  end
end
