require 'spec_helper'
require 'obcan_justice_sk'
require_relative '../../../app/mappers/obcan_justice_sk/judge_mapper'
require_relative '../../../app/mappers/obcan_justice_sk/court_mapper'

RSpec.describe ObcanJusticeSk::JudgeMapper do
  subject { described_class.new(double(:jduge, id: 1, data: data)) }

  let(:data) { JSON.parse(fixture('obcan_justice_sk/mappers/judge.json').read) }

  describe '#uri' do
    it 'maps uri from guid' do
      expect(subject.uri).to eql('https://www.justice.gov.sk/sudy-a-rozhodnutia/sudy/sudcovia/sudca_1')
    end
  end

  describe '#name' do
    it 'maps name' do
      expect(subject.name).to eql(
        addition: nil,
        first: 'Alena',
        flags: [],
        last: 'Adamcová',
        middle: nil,
        prefix: 'JUDr.',
        role: nil,
        suffix: nil,
        unprocessed: 'JUDr. Alena ADAMCOVÁ',
        value: 'JUDr. Alena Adamcová'
      )
    end
  end

  describe '#position' do
    it 'maps position' do
      expect(subject.position).to eql('sudca')
    end
  end

  describe '#status' do
    it 'maps status' do
      expect(subject.active).to be_truthy
    end
  end

  describe '#court' do
    it 'maps court' do
      expect(subject.court).to eql('Najvyšší súd Slovenskej republiky')
    end
  end

  describe '#temporary_court' do
    it 'maps temporary court' do
      expect(subject.temporary_court).to eql('Krajský súd Nitra')
    end
  end

  context 'when part of judicial council' do
    describe '#judicial_council_chairman_court_names' do
      subject do
        described_class.new(
          double(
            :court,
            id: 1,
            data: data,
            courts_as_judicial_council_chairman: [double(:court, data: { nazov: 'Krajský súd v Nitre' })]
          )
        )
      end

      it 'provides court names where judge is a chairman of judicial council' do
        expect(subject.judicial_council_chairman_court_names).to eql(['Krajský súd Nitra'])
      end
    end

    describe '#judicial_council_member_court_names' do
      subject do
        described_class.new(
          double(
            :court,
            id: 1,
            data: data,
            courts_as_judicial_council_member: [double(:court, data: { nazov: 'Krajský súd v Nitre' })]
          )
        )
      end

      it 'provides court names where judge is a member of judicial council' do
        expect(subject.judicial_council_member_court_names).to eql(['Krajský súd Nitra'])
      end
    end
  end
end
