require 'spec_helper'
require 'info_sud'
require 'active_support/all'
require_relative '../../../app/mappers/info_sud/judge_mapper'

RSpec.describe InfoSud::JudgeMapper do
  subject { InfoSud::JudgeMapper.new(judge) }

  let(:judge) { double(:judge, data: data) }
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
      "longitude_sudu" => "19.6662481"
    }
  }

  describe '#uri' do
    it 'maps judge uri' do
      expect(subject.uri).to eql('https://obcan.justice.sk/infosud/-/infosud/reg-detail/sudca/sudca_827')
    end
  end

  describe '#name' do
    it 'maps judge name' do
      expect(subject.name).to eql('JUDr. Magdaléna Balážová')
    end
  end

  describe '#partitioned_name' do
    it 'maps judge name into parts' do
      expect(subject.partitioned_name).to eql(
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
    it 'maps judge activity' do
      expect(subject.active).to be_truthy
    end

    context 'when activity is missing' do
      let(:data) { { "stav" => nil } }

      it 'maps judge as active' do
        expect(subject.active).to be_truthy
      end
    end

    context 'when activity is any other than active' do
      let(:data) { { "stav" => '04' } }

      it 'maps judge as inactive' do
        expect(subject.active).to be_falsey
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
end
