require 'spec_helper'
require 'obcan_justice_sk'
require_relative '../../../app/mappers/obcan_justice_sk/criminal_hearing_mapper'
require_relative '../../../app/services/obcan_justice_sk/judge_finder'

RSpec.describe ObcanJusticeSk::CriminalHearingMapper do
  subject do
    described_class.new(double(:criminal_hearing, id: 1, class: double(:class, name: 'CriminalHearing'), data: data))
  end

  let(:data) { JSON.parse(fixture('obcan_justice_sk/mappers/criminal_hearing.json').read) }

  describe '#uri' do
    it 'maps uri from guid' do
      expect(subject.uri).to eql(
        'https://www.justice.gov.sk/sudy-a-rozhodnutia/pojednavania/trestne-pojednavania/detail/?eid=CCDA6228-8F0F-4364-B60C-5BA527607C8B_711769'
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
      expect(subject.source_class).to eql('CriminalHearing')
    end
  end

  describe '#source_class_id' do
    it 'maps source class id' do
      expect(subject.source_class_id).to eql(1)
    end
  end

  describe '#type' do
    it 'maps type' do
      expect(subject.type).to eql('Trestné')
    end
  end

  describe '#judges' do
    it 'maps judges' do
      judge = double(:judge, name: 'JUDr. Vladimír Tamaškovič')

      allow(ObcanJusticeSk::JudgeFinder).to receive(:find_by).with(
        name: 'JUDr. Vladimír Tamaškovič',
        guid: nil
      ).and_return(judge)

      expect(subject.judges).to eql([judge])
    end
  end

  describe '#court' do
    it 'maps court' do
      expect(subject.court).to eql('Okresný súd Nové Zámky')
    end
  end

  describe '#original_court' do
    it 'maps original court' do
      expect(subject.original_court).to eql(nil)
    end
  end

  describe '#case_number' do
    it 'maps case number' do
      expect(subject.case_number).to eql('4Tcud/1/2024')
    end
  end

  describe '#original_case_number' do
    it 'maps original case number' do
      expect(subject.original_case_number).to eql(nil)
    end
  end

  describe '#file_number' do
    it 'maps file number' do
      expect(subject.file_number).to eql('4424010012')
    end
  end

  describe '#subject' do
    it 'maps subject' do
      expect(subject.subject).to eql('Návrh na nariadenie výkonu uznaného cudzieho rozhodnutia')
    end
  end

  describe '#section' do
    it 'maps section' do
      expect(subject.section).to eql('Trestný')
    end
  end

  describe '#form' do
    it 'maps form' do
      expect(subject.form).to eql('Pojednávanie a rozhodnutie')
    end
  end

  describe '#room' do
    it 'maps room' do
      expect(subject.room).to eql('33')
    end
  end

  describe '#date' do
    it 'maps date' do
      expect(subject.date).to eql(Time.parse('02-05-2024 08:30 +0200'))
    end
  end

  describe '#note' do
    it 'maps note' do
      expect(subject.note).to eql(nil)
    end
  end

  describe '#proposers' do
    it 'maps proposers' do
      expect(subject.proposers).to eql([])
    end
  end

  describe '#opponents' do
    it 'maps opponents' do
      expect(subject.opponents).to eql([])
    end
  end

  describe '#defendants' do
    it 'maps defendants' do
      expect(subject.defendants).to eql(['A. B.'])
    end
  end

  describe '#selfjudge' do
    it 'maps selfjudge' do
      expect(subject.selfjudge).to eql(false)
    end
  end

  describe '#special_type' do
    it 'maps special type' do
      expect(subject.special_type).to eql('Trestné pojednávanie')
    end
  end

  describe '#chair_judges' do
    it 'maps chair judges' do
      expect(subject.chair_judges).to eql([])
    end
  end

  context 'as hearing for special criminal court' do
    let(:data) { JSON.parse(fixture('obcan_justice_sk/mappers/special_criminal_hearing.json').read) }

    describe '#court' do
      describe '#type' do
        it 'maps type' do
          expect(subject.type).to eql('Špecializovaného trestného súdu')
        end
      end

      it 'maps court' do
        expect(subject.court).to eql('Špecializovaný trestný súd')
      end

      describe '#judges' do
        it 'maps judges' do
          expect(subject.judges).to eql([])
        end
      end

      describe '#chair_judges' do
        it 'maps chair judges' do
          judge = double(:judge, name: 'JUDr. Jozef Pikna')

          allow(ObcanJusticeSk::JudgeFinder).to receive(:find_by).with(name: 'JUDr. Jozef Pikna', guid: nil).and_return(
            judge
          )

          expect(subject.chair_judges).to eql([judge])
        end
      end

      describe '#defendants' do
        it 'maps defendants' do
          expect(subject.defendants).to eql(['A. B.'])
        end
      end
    end
  end
end
