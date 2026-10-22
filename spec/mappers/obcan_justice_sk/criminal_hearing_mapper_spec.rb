# frozen_string_literal: true

require 'rails_helper'

RSpec.describe ObcanJusticeSk::CriminalHearingMapper do
  subject(:mapper) { described_class.new(build(:obcan_justice_sk_criminal_hearing, id: 1, data:)) }

  let(:data) { JSON.parse(file_fixture('obcan_justice_sk/mappers/criminal_hearing.json').read) }

  describe '#uri' do
    it 'maps uri from guid' do
      expect(mapper.uri).to eql(
        'https://www.justice.gov.sk/sudy-a-rozhodnutia/pojednavania/trestne-pojednavania/detail/?eid=CCDA6228-8F0F-4364-B60C-5BA527607C8B_711769'
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
      expect(mapper.source_class).to eq('ObcanJusticeSk::CriminalHearing')
    end
  end

  describe '#source_class_id' do
    it 'maps source class id' do
      expect(mapper.source_class_id).to be(1)
    end
  end

  describe '#type' do
    it 'maps type' do
      expect(mapper.type).to eql('Trestné')
    end
  end

  describe '#judges' do
    it 'maps judges by name' do
      judge = create(:judge, name: 'JUDr. Vladimír Tamaškovič')

      expect(mapper.judges).to eq([judge])
    end
  end

  describe '#court' do
    it 'maps court' do
      expect(mapper.court).to eql('Okresný súd Nové Zámky')
    end
  end

  describe '#original_court' do
    it 'maps original court' do
      expect(mapper.original_court).to be_nil
    end
  end

  describe '#case_number' do
    it 'maps case number' do
      expect(mapper.case_number).to eql('4Tcud/1/2024')
    end
  end

  describe '#original_case_number' do
    it 'maps original case number' do
      expect(mapper.original_case_number).to be_nil
    end
  end

  describe '#file_number' do
    it 'maps file number' do
      expect(mapper.file_number).to eql('4424010012')
    end
  end

  describe '#subject' do
    it 'maps subject' do
      expect(mapper.subject).to eql('Návrh na nariadenie výkonu uznaného cudzieho rozhodnutia')
    end
  end

  describe '#section' do
    it 'maps section' do
      expect(mapper.section).to eql('Trestný')
    end
  end

  describe '#form' do
    it 'maps form' do
      expect(mapper.form).to eql('Pojednávanie a rozhodnutie')
    end
  end

  describe '#room' do
    it 'maps room' do
      expect(mapper.room).to eql('33')
    end
  end

  describe '#date' do
    it 'maps date' do
      expect(mapper.date).to eql(Time.parse('02-05-2024 08:30 +0200'))
    end
  end

  describe '#note' do
    it 'maps note' do
      expect(mapper.note).to be_nil
    end
  end

  describe '#proposers' do
    it 'maps proposers' do
      expect(mapper.proposers).to eql([])
    end
  end

  describe '#opponents' do
    it 'maps opponents' do
      expect(mapper.opponents).to eql([])
    end
  end

  describe '#defendants' do
    it 'maps defendants' do
      expect(mapper.defendants).to eql(['A. B.'])
    end
  end

  describe '#selfjudge' do
    it 'maps selfjudge' do
      expect(mapper.selfjudge).to be(false)
    end
  end

  describe '#special_type' do
    it 'maps special type' do
      expect(mapper.special_type).to eql('Trestné pojednávanie')
    end
  end

  describe '#chair_judges' do
    it 'maps chair judges' do
      expect(mapper.chair_judges).to eql([])
    end
  end

  context 'with a hearing at the special criminal court' do
    let(:data) { JSON.parse(file_fixture('obcan_justice_sk/mappers/special_criminal_hearing.json').read) }

    it 'maps type' do
      expect(mapper.type).to eq('Špecializovaného trestného súdu')
    end

    it 'maps court' do
      expect(mapper.court).to eq('Špecializovaný trestný súd')
    end

    it 'maps no judges' do
      expect(mapper.judges).to eq([])
    end

    it 'maps chair judges by name' do
      judge = create(:judge, name: 'JUDr. Jozef Pikna')

      expect(mapper.chair_judges).to eq([judge])
    end

    it 'maps defendants' do
      expect(mapper.defendants).to eq(['A. B.'])
    end
  end

  context 'with a record that gives no court, form, date or type' do
    let(:data) do
      JSON.parse(file_fixture('obcan_justice_sk/mappers/criminal_hearing.json').read)
          .except('sud', 'ukonForma', 'datumPojednavania', 'typ')
    end

    it 'maps none of them' do
      expect([mapper.court, mapper.form, mapper.date, mapper.special_type]).to all(be_nil)
    end
  end
end
