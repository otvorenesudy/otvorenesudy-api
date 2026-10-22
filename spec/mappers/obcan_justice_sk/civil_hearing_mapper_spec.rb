# frozen_string_literal: true

require 'rails_helper'

RSpec.describe ObcanJusticeSk::CivilHearingMapper do
  subject(:mapper) { described_class.new(build(:obcan_justice_sk_civil_hearing, id: 1, data:)) }

  let(:data) { JSON.parse(file_fixture('obcan_justice_sk/mappers/civil_hearing.json').read) }

  describe '#uri' do
    it 'maps uri from guid' do
      expect(mapper.uri).to eql(
        'https://www.justice.gov.sk/sudy-a-rozhodnutia/sudy/pojednavania/f5c7b3ce-e9d6-44ed-adca-66b57190e542'
      )
    end
  end

  describe '#source' do
    it 'maps source' do
      expect(mapper.source).to eql('JusticeGovSk')
    end
  end

  describe '#source_class' do
    it 'maps source class' do
      expect(mapper.source_class).to eq('ObcanJusticeSk::CivilHearing')
    end
  end

  describe '#source_class_id' do
    it 'maps source class id' do
      expect(mapper.source_class_id).to be(1)
    end
  end

  describe '#type' do
    it 'maps type' do
      expect(mapper.type).to eql('Civilné')
    end
  end

  describe '#judges' do
    it 'maps judges, found by name when the record has no id for them' do
      judge = create(:judge, name: 'Mgr. Denisa Slivová')

      expect(mapper.judges).to eq([judge])
    end
  end

  describe '#court' do
    it 'maps court' do
      expect(mapper.court).to eql('Správny súd Banská Bystrica')
    end
  end

  describe '#original_court' do
    it 'maps original court' do
      expect(mapper.original_court).to be_nil
    end
  end

  describe '#case_number' do
    it 'maps case number' do
      expect(mapper.case_number).to eql('ZA-31S/55/2018')
    end
  end

  describe '#original_case_number' do
    it 'maps original case number' do
      expect(mapper.original_case_number).to be_nil
    end
  end

  describe '#file_number' do
    it 'maps file number' do
      expect(mapper.file_number).to eql('5018200202')
    end
  end

  describe '#subject' do
    it 'maps subject' do
      expect(mapper.subject).to eql('preskúmanie rozh. č. 100692444/2018 z 9.4.2018')
    end
  end

  describe '#section' do
    it 'maps section' do
      expect(mapper.section).to eql('S')
    end
  end

  describe '#form' do
    it 'maps form' do
      expect(mapper.form).to eql('Pojednávanie a rozhodnutie')
    end
  end

  describe '#room' do
    it 'maps room' do
      expect(mapper.room).to be_nil
    end
  end

  describe '#date' do
    it 'maps date' do
      expect(mapper.date).to eql(Time.parse('2019/11/13 10:20 +0100'))
    end
  end

  describe '#note' do
    it 'maps note' do
      expect(mapper.note).to be_nil
    end
  end

  describe '#proposers' do
    it 'maps proposers' do
      expect(mapper.proposers).to eql(['ABC'])
    end
  end

  describe '#opponents' do
    it 'maps opponents' do
      expect(mapper.opponents).to eql(['Finančné riaditeľstvo SR, Banská Bystrica'])
    end
  end

  describe '#defendants' do
    it 'maps defendants' do
      expect(mapper.defendants).to eql([])
    end
  end

  describe '#selfjudge' do
    it 'maps selfjudge' do
      expect(mapper.selfjudge).to be_nil
    end
  end

  describe '#special_type' do
    it 'maps special type' do
      expect(mapper.special_type).to be_nil
    end
  end

  describe '#chair_judges' do
    it 'maps chair judges' do
      expect(mapper.chair_judges).to eql([])
    end
  end

  context 'with original court and case number' do
    let(:data) { JSON.parse(file_fixture('obcan_justice_sk/mappers/civil_hearing_with_original_court.json').read) }

    describe '#court' do
      it 'maps court' do
        expect(mapper.court).to eql('Okresný súd Nitra')
      end
    end

    describe '#original_court' do
      it 'maps original court' do
        expect(mapper.original_court).to eql('Okresný súd Topoľčany')
      end
    end

    describe '#case_number' do
      it 'maps case number' do
        expect(mapper.case_number).to eql('TO-10P/42/2023')
      end
    end

    describe '#original_case_number' do
      it 'maps original case number' do
        expect(mapper.original_case_number).to eql('10P/42/2023')
      end
    end
  end
end
