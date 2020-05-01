require 'spec_helper'
require 'info_sud'
require_relative '../../../app/mappers/info_sud/judge_mapper'

RSpec.describe InfoSud::JudgeMapper do
  subject { InfoSud::JudgeMapper.new(data) }

  let(:data) {
    {
      "sud" => "Okresný súd Lučenec",
      "asud" => "Okresný súd Lučenec",
      "guid" => "sudca_827",
      "meno" => "JUDr. Magdaléna BALÁŽOVÁ",
      "stav" => "01",
      "funkcia" => "Sudca",
      "sud_guid" => "141",
      "typ_sudu" => "Okresný súd",
      "asud_guid" => "141",
      "kraj_sudu" => "Banskobystrický kraj",
      "okres_sudu" => "Okres Lučenec",
      "stav_zmena" => "31.3.2008",
      "aktualizacia" => "2015-12-08T00:00:00Z",
      "lattitude_sudu" => "48.3274866",
      "longitude_sudu" => "19.6662481",
      "poznamka" => "- od 1. februára 2004 má prerušený výkon funkcie sudcu podľa § 24 ods. 4 zákona č. 385/2000 Z.z.",
      "aktivita"=>"label.sudca.aktivny"
    }
  }

  describe '#uri' do
    it 'maps judge uri' do
      expect(subject.uri).to eql('https://obcan.justice.sk/infosud/-/infosud/reg-detail/sudca/sudca_827')
    end
  end

  describe '#name' do
    it 'maps judge name into parts' do
      expect(subject.name).to eql(
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
      expect(subject.active).to be_truthy
    end

    context 'when status is active, but probably prosecuted' do
      let(:data) { { 'stav' => '02' } }

      it 'maps judge as active' do
        expect(subject.active).to be_truthy
      end
    end

    context 'when status is terminated' do
      let(:data) { { 'stav' => '03' } }

      it 'maps judge as active' do
        expect(subject.active).to be_falsey
      end
    end

    context 'when status is missing' do
      let(:data) { { 'stav' => nil } }

      it 'maps judge as active' do
        expect(subject.active).to be_truthy
      end
    end

    context 'when ststus is inactive' do
      let(:data) { { 'stav' => '04' } }

      it 'maps judge as inactive' do
        expect(subject.active).to be_falsey
      end
    end

    context 'when status is as position changed' do
      let(:data) { { 'stav' => '05' } }

      it 'maps judge as active' do
        expect(subject.active).to be_truthy
      end
    end

    context 'when status is as 06' do
      let(:data) { { 'stav' => '06' } }

      it 'maps judge as active' do
        expect(subject.active).to be_truthy
      end
    end
  end

  describe '#status' do
    it 'maps judge status' do
      expect(subject.status).to eq(:active)
    end

    context 'when status is active, but probably prosecuted' do
      let(:data) { { 'stav' => '02' } }

      it 'maps judge as active' do
        expect(subject.status).to eq(:active)
      end
    end

    context 'when status is terminated' do
      let(:data) { { 'stav' => '03' } }

      it 'maps judge as terminated' do
        expect(subject.status).to eq(:terminated)
      end
    end

    context 'when status is missing' do
      let(:data) { { 'stav' => nil } }

      it 'maps judge as active' do
        expect(subject.status).to be_nil
      end
    end

    context 'when ststus is inactive' do
      let(:data) { { 'stav' => '04' } }

      it 'maps judge as inactive' do
        expect(subject.status).to eq(:inactive)
      end
    end

    context 'when status is as position changed' do
      let(:data) { { 'stav' => '05' } }

      it 'maps judge as active' do
        expect(subject.status).to eq(:active)
      end
    end

    context 'when status is as 06' do
      let(:data) { { 'stav' => '06' } }

      it 'maps judge as active' do
        expect(subject.status).to eq(:active)
      end
    end
  end

  describe '#position' do
    it 'maps judge position at current court' do
      expect(subject.position).to eql('sudca')
    end
  end

  describe '#court' do
    it 'maps current court' do
      expect(subject.court).to eql('Okresný súd Lučenec')
    end
  end

  describe '#temporary_court' do
    it 'does not map temporary assigned court judge is assigned to' do
      expect(subject.temporary_court).to be_nil
    end

    context 'when temporary court and current court are not the same' do
      let(:data) {
        {
          "sud" => "Okresný súd Lučenec",
          "asud" => "Krajský súd Trenčín"
        }
      }

      it 'maps temporary court' do
        expect(subject.temporary_court).to eql('Krajský súd Trenčín')
      end
    end
  end

  describe '#note' do
    it 'parses note' do
      expect(subject.note).to eql('- od 1. februára 2004 má prerušený výkon funkcie sudcu podľa § 24 ods. 4 zákona č. 385/2000 Z.z.')
    end
  end
end
