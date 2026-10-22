# frozen_string_literal: true

require 'rails_helper'

RSpec.describe InfoSud::HearingMapper do
  subject(:mapper) { described_class.new(build(:info_sud_hearing, id: 1, data:)) }

  let(:data) do
    {
      'ecli' => 'ECLI:SK:OSKE1:2015:7115010154.5',
      'guid' => '94fed4fd-af4a-42c3-8c21-788358207927',
      'usek' => 'T',
      'predmet' => '4Pv 461/14 - § 189 ods. 1 Tr. zák.',
      'sud_typ' => 'Okresný súd',
      'poznamka' => 'poznamka',
      'sud_guid' => '148',
      'sud_kraj' => 'Košický kraj',
      'miestnost' => '135',
      'sud_nazov' => 'Okresný súd Košice I',
      'sud_okres' => 'Okres Košice I',
      'sudca_guid' => ['185'],
      'sudca_meno' => ['JUDr. Margaréta Hlaváčková'],
      'forma_ukonu' => 'Hlavné pojednávanie s rozhodnutím',
      'navrhovatel' => ['Peter Pan'],
      'je_samosudca' => true,
      'mena_odporcov' => ['Peter Parker'],
      'spisova_znacka' => '3T/9/2015',
      'datum_zapocatia' => nil,
      'index_timestamp' => '2015-12-03T12:26:05.395Z',
      'mena_obzalovanych' => ['Peter Smith'],
      'datum_a_cas_pojednavania' => '2015-12-07T12:30:00Z',
      'identifikacne_cislo_spisu' => '7115010154'
    }
  end

  describe '#uri' do
    it 'maps uri' do
      expect(mapper.uri).to eql(
        'https://obcan.justice.sk/infosud/-/infosud/i-detail/pojednavanie/94fed4fd-af4a-42c3-8c21-788358207927'
      )
    end
  end

  describe '#case_number' do
    it 'maps case number' do
      expect(mapper.case_number).to eql('3T/9/2015')
    end
  end

  describe '#file_number' do
    it 'maps file number' do
      expect(mapper.file_number).to eql('7115010154')
    end
  end

  describe '#date' do
    it 'maps utc date' do
      expect(mapper.date).to eql(Time.utc(2015, 12, 7, 12, 30))
    end
  end

  describe '#room' do
    it 'maps room' do
      expect(mapper.room).to eql('135')
    end
  end

  describe '#selfjudge' do
    it 'maps self judge' do
      expect(mapper.selfjudge).to be(true)
    end
  end

  describe '#note' do
    it 'maps note' do
      expect(mapper.note).to eql('poznamka')
    end
  end

  describe '#special_type' do
    it 'maps special type' do
      expect(mapper.special_type).to be_nil
    end
  end

  describe '#court' do
    it 'maps court' do
      expect(mapper.court).to eql('Mestský súd Košice')
    end
  end

  describe '#type' do
    context 'when court is specialized' do
      let(:data) { { 'sud_nazov' => 'Špecializovaný trestný súd' } }

      it 'maps type to special' do
        expect(mapper.type).to eql('Špecializovaného trestného súdu')
      end
    end

    context 'when section is criminal and court it other than specilized' do
      let(:data) { { 'usek' => 'T' } }

      it 'maps type to criminal' do
        expect(mapper.type).to eql('Trestné')
      end
    end

    context 'when section is other than criminal' do
      let(:data) { { 'usek' => 'C' } }

      it 'maps type to civil' do
        expect(mapper.type).to eql('Civilné')
      end
    end
  end

  describe '#section' do
    it 'maps section' do
      expect(mapper.section).to eql('T')
    end
  end

  describe '#subject' do
    it 'maps subject' do
      expect(mapper.subject).to eql('4Pv 461/14 - § 189 ods. 1 Tr. zák.')
    end
  end

  describe '#form' do
    it 'maps form' do
      expect(mapper.form).to eql('Hlavné pojednávanie s rozhodnutím')
    end
  end

  describe '#proposers' do
    it 'maps proposers' do
      expect(mapper.proposers).to eql(['Peter Pan'])
    end
  end

  describe '#opponents' do
    it 'maps opponents' do
      expect(mapper.opponents).to eql(['Peter Parker'])
    end
  end

  describe '#defendants' do
    it 'maps defendants' do
      expect(mapper.defendants).to eql(['Peter Smith'])
    end
  end

  describe '#judges' do
    let!(:judge) { create(:judge, name: 'JUDr. Margaréta Hlaváčková') }

    it 'maps judges by name' do
      expect(mapper.judges).to eq([judge])
      expect(mapper.chair_judges).to be_empty
    end

    context 'when court is specialized' do
      let(:data) { { 'sud_nazov' => 'Špecializovaný trestný súd', 'sudca_meno' => ['JUDr. Margaréta Hlaváčková'] } }

      it 'maps judges as chair' do
        expect(mapper.chair_judges).to eq([judge])
        expect(mapper.judges).to be_empty
      end
    end
  end
end
