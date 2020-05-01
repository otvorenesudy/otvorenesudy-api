require 'rails_helper'

RSpec.feature 'Import Judges' do
  context 'from InfoSud' do
    let!(:source) { create(:source, :justice_gov_sk) }
    let(:data) { fixture('info_sud/judges.json').read  }
    let(:updated_data) { fixture('info_sud/updated_judges.json').read }

    before :each do
      create(:court, name: 'Okresný súd Levice')
      create(:court, name: 'Krajský súd Nitra')
      create(:court, name: 'Okresný súd Bratislava II')
      create(:court, name: 'Krajský súd Trenčín')
    end

    scenario 'imports judges' do
      InfoSud::Importer.import(data, repository: InfoSud::Judge)

      expect(InfoSud::Judge.count).to eql(2)
      expect(Judge.count).to eql(2)

      judge = Judge.find_by(name: 'JUDr. Martina Balegová')

      expect(judge.attributes.deep_symbolize_keys.except(:id, :created_at, :updated_at)).to eql(
        uri: 'https://obcan.justice.sk/infosud/-/infosud/reg-detail/sudca/sudca_1508',
        source_id: source.id,
        name: 'JUDr. Martina Balegová',
        name_unprocessed: 'JUDr. Martina BALEGOVÁ',
        prefix: 'JUDr.',
        first: 'Martina',
        middle: nil,
        last: 'Balegová',
        suffix: nil,
        addition: nil
      )

      employments = judge.employments.order(:id)

      expect(employments.size).to eql(2)

      expect(employments[0].court).to eql(Court.find_by(name: 'Okresný súd Levice'))
      expect(employments[0].position).to eql(Judge::Position.find_by(value: 'sudca'))
      expect(employments[0].active).to eql(true)
      expect(employments[0].status).to eql('active')
      expect(employments[0].note).to be_nil

      expect(employments[1].court).to eql(Court.find_by(name: 'Krajský súd Nitra'))
      expect(employments[1].position).to eql(Judge::Position.find_by(value: 'sudca'))
      expect(employments[1].active).to eql(true)
      expect(employments[1].status).to be_nil
      expect(employments[1].note).to be_nil
    end

    scenario 'updates judges and preserves their employment history' do
      Timecop.travel(30.minutes.ago) do
        InfoSud::Importer.import(data, repository: InfoSud::Judge)
      end

      updated_at = 1.minute.ago

      Timecop.freeze(updated_at) do
        InfoSud::Importer.import(updated_data, repository: InfoSud::Judge)
      end

      expect(Judge.where('updated_at >= ?', updated_at).size).to eql(2)

      judge = Judge.find_by(name: 'JUDr. Martina Balegová')

      expect(judge.attributes.deep_symbolize_keys.except(:id, :created_at, :updated_at)).to eql(
        uri: 'https://obcan.justice.sk/infosud/-/infosud/reg-detail/sudca/sudca_1508',
        source_id: source.id,
        name: 'JUDr. Martina Balegová',
        name_unprocessed: 'JUDr. Martina BALEGOVÁ',
        prefix: 'JUDr.',
        first: 'Martina',
        middle: nil,
        last: 'Balegová',
        suffix: nil,
        addition: nil
      )

      employments = judge.employments.order(:id)

      expect(employments.size).to eql(3)

      expect(employments[0].court).to eql(Court.find_by(name: 'Okresný súd Levice'))
      expect(employments[0].position).to eql(Judge::Position.find_by(value: 'sudca'))
      expect(employments[0].active).to eql(true)
      expect(employments[0].status).to eql('active')
      expect(employments[0].note).to eql('od 1. novembra 2015 do 31. októbra 2016 je dočasne pridelená na KS v Trenčíne')

      expect(employments[1].court).to eql(Court.find_by(name: 'Krajský súd Nitra'))
      expect(employments[1].position).to eql(Judge::Position.find_by(value: 'sudca'))
      expect(employments[1].active).to eql(false)
      expect(employments[1].status).to be_nil
      expect(employments[1].note).to be_nil

      expect(employments[2].court).to eql(Court.find_by(name: 'Krajský súd Trenčín'))
      expect(employments[2].position).to eql(Judge::Position.find_by(value: 'sudca'))
      expect(employments[2].active).to eql(true)
      expect(employments[2].status).to be_nil
      expect(employments[2].note).to be_nil

      judge = Judge.find_by(name: 'JUDr. Ivana Dančová')

      employments = judge.employments.order(:id)

      expect(employments[0].court).to eql(Court.find_by(name: 'Okresný súd Bratislava II'))
      expect(employments[0].position).to eql(Judge::Position.find_by(value: 'sudca'))
      expect(employments[0].active).to eql(false)
      expect(employments[0].status).to eql('terminated')
      expect(employments[0].note).to be_nil
    end
  end
end
