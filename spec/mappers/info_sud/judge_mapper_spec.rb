# frozen_string_literal: true

require 'rails_helper'

RSpec.describe InfoSud::JudgeMapper do
  subject(:mapper) { described_class.new(build(:info_sud_judge, id: 1, data:)) }

  let(:data) do
    {
      'sud' => 'Okresný súd Lučenec',
      'asud' => 'Okresný súd Lučenec',
      'guid' => 'sudca_827',
      'meno' => 'JUDr. Magdaléna BALÁŽOVÁ',
      'stav' => '01',
      'funkcia' => 'Sudca',
      'sud_guid' => '141',
      'typ_sudu' => 'Okresný súd',
      'asud_guid' => '141',
      'kraj_sudu' => 'Banskobystrický kraj',
      'okres_sudu' => 'Okres Lučenec',
      'stav_zmena' => '31.3.2008',
      'aktualizacia' => '2015-12-08T00:00:00Z',
      'lattitude_sudu' => '48.3274866',
      'longitude_sudu' => '19.6662481',
      'poznamka' => '- od 1. februára 2004 má prerušený výkon funkcie sudcu podľa § 24 ods. 4 zákona č. 385/2000 Z.z.',
      'aktivita' => 'label.sudca.aktivny'
    }
  end

  describe '#uri' do
    it 'maps judge uri' do
      expect(mapper.uri).to eql('https://obcan.justice.sk/infosud/-/infosud/reg-detail/sudca/sudca_827')
    end
  end

  describe '#name' do
    it 'maps judge name into parts' do
      expect(mapper.name).to eql(
        value: 'JUDr. Magdaléna Balážová',
        unprocessed: 'JUDr. Magdaléna BALÁŽOVÁ',
        prefix: 'JUDr.',
        first: 'Magdaléna',
        middle: nil,
        last: 'Balážová',
        suffix: nil,
        addition: nil,
        flags: [],
        role: nil
      )
    end
  end

  describe '#active' do
    it 'maps judge status' do
      expect(mapper).to be_active
    end

    context 'when status is active, but probably prosecuted' do
      let(:data) { { 'stav' => '02' } }

      it 'maps judge as active' do
        expect(mapper).to be_active
      end
    end

    context 'when status is terminated' do
      let(:data) { { 'stav' => '03' } }

      it 'maps judge as active' do
        expect(mapper).not_to be_active
      end
    end

    context 'when status is missing' do
      let(:data) { { 'stav' => nil } }

      it 'maps judge as active' do
        expect(mapper).to be_active
      end
    end

    context 'when ststus is inactive' do
      let(:data) { { 'stav' => '04' } }

      it 'maps judge as inactive' do
        expect(mapper).not_to be_active
      end
    end

    context 'when status is as position changed' do
      let(:data) { { 'stav' => '05' } }

      it 'maps judge as active' do
        expect(mapper).to be_active
      end
    end

    context 'when status is as 06' do
      let(:data) { { 'stav' => '06' } }

      it 'maps judge as active' do
        expect(mapper).to be_active
      end
    end
  end

  describe '#status' do
    it 'maps judge status' do
      expect(mapper.status).to eq(:active)
    end

    context 'when status is active, but probably prosecuted' do
      let(:data) { { 'stav' => '02' } }

      it 'maps judge as active' do
        expect(mapper.status).to eq(:active)
      end
    end

    context 'when status is terminated' do
      let(:data) { { 'stav' => '03' } }

      it 'maps judge as terminated' do
        expect(mapper.status).to eq(:terminated)
      end
    end

    context 'when status is missing' do
      let(:data) { { 'stav' => nil } }

      it 'maps judge as active' do
        expect(mapper.status).to be_nil
      end
    end

    context 'when ststus is inactive' do
      let(:data) { { 'stav' => '04' } }

      it 'maps judge as inactive' do
        expect(mapper.status).to eq(:inactive)
      end
    end

    context 'when status is as position changed' do
      let(:data) { { 'stav' => '05' } }

      it 'maps judge as active' do
        expect(mapper.status).to eq(:active)
      end
    end

    context 'when status is as 06' do
      let(:data) { { 'stav' => '06' } }

      it 'maps judge as active' do
        expect(mapper.status).to eq(:active)
      end
    end
  end

  describe '#position' do
    it 'maps judge position at current court' do
      expect(mapper.position).to eql('sudca')
    end
  end

  describe '#court' do
    it 'maps current court' do
      expect(mapper.court).to eql('Okresný súd Lučenec')
    end
  end

  describe '#temporary_court' do
    it 'does not map temporary assigned court judge is assigned to' do
      expect(mapper.temporary_court).to be_nil
    end

    context 'when temporary court and current court are not the same' do
      let(:data) do
        {
          'sud' => 'Okresný súd Lučenec',
          'asud' => 'Krajský súd Trenčín'
        }
      end

      it 'maps temporary court' do
        expect(mapper.temporary_court).to eql('Krajský súd Trenčín')
      end
    end
  end

  describe '#note' do
    it 'parses note' do
      expect(mapper.note).to eql(
        '- od 1. februára 2004 má prerušený výkon funkcie sudcu podľa § 24 ods. 4 zákona č. 385/2000 Z.z.'
      )
    end
  end

  context 'with a judge the record names at no court' do
    let(:data) { { 'sud' => nil } }

    it 'maps no court' do
      expect(mapper.court).to be_nil
    end
  end
end
