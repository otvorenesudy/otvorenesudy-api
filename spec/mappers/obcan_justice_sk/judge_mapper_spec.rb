# frozen_string_literal: true

require 'rails_helper'

RSpec.describe ObcanJusticeSk::JudgeMapper do
  subject(:mapper) { described_class.new(judge) }

  let(:judge) { build(:obcan_justice_sk_judge, id: 1, data:) }

  let(:data) { JSON.parse(file_fixture('obcan_justice_sk/mappers/judge.json').read) }

  describe '#uri' do
    it 'maps uri from guid' do
      expect(mapper.uri).to eql('https://www.justice.gov.sk/sudy-a-rozhodnutia/sudy/sudcovia/sudca_1')
    end
  end

  describe '#name' do
    it 'maps name' do
      expect(mapper.name).to eql(
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
      expect(mapper.position).to eql('sudca')
    end
  end

  describe '#status' do
    it 'maps status' do
      expect(mapper.active).to be_truthy
    end
  end

  describe '#court' do
    it 'maps court' do
      expect(mapper.court).to eql('Najvyšší súd Slovenskej republiky')
    end
  end

  describe '#temporary_court' do
    it 'maps temporary court' do
      expect(mapper.temporary_court).to eql('Krajský súd Nitra')
    end
  end

  context 'when part of judicial council' do
    def create_court_listing_judge(role)
      create(:obcan_justice_sk_court, data: { 'registreGuid' => 'sud_123', 'nazov' => 'Krajský súd v Nitre',
                                              role => { 'sudcovia' => [{ 'id' => '1', 'meno' => 'Alena Adamcová' }] } })
    end

    describe '#judicial_council_chairman_court_names' do
      it 'provides court names where judge is a chairman of judicial council' do
        create_court_listing_judge('srPredseda')

        expect(mapper.judicial_council_chairman_court_names).to eq(['Krajský súd Nitra'])
      end
    end

    describe '#judicial_council_member_court_names' do
      it 'provides court names where judge is a member of judicial council' do
        create_court_listing_judge('srClen')

        expect(mapper.judicial_council_member_court_names).to eq(['Krajský súd Nitra'])
      end
    end
  end
end
