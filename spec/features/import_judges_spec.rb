require 'rails_helper'

RSpec.feature 'Import Judges' do
  let!(:source) { create(:source, :justice_gov_sk) }
  let(:data) { fixture('info_sud/judges.json').read  }
  let(:updated_data) { fixture('info_sud/updated_judges.json').read }

  before :each do
    create(:court, name: 'Okresný súd Levice')
    create(:court, name: 'Krajský súd Nitra')
    create(:court, name: 'Okresný súd Bratislava II')
    create(:court, name: 'Krajský súd Trenčín')
  end

  scenario 'imports judges from InfoSud archives', vcr: { cassette_name: 'info_sud/judges' } do
    InfoSud::Importer.import(data, repository: InfoSud::Judge)

    expect(InfoSud::Judge.count).to eql(2)
    expect(Judge.count).to eql(2)

    record = InfoSud::Judge.find_by(guid: 'sudca_1508')
    judge = Judge.find_by(name: 'JUDr. Martina Balegová')

    expect(record.attributes.deep_symbolize_keys.except(:id, :created_at, :updated_at)).to eql(
      :guid => "sudca_1508",
      :data => {
        :sud => "Okresný súd Levice",
        :asud => "Krajský súd v Nitre",
        :guid => "sudca_1508",
        :meno => "JUDr. Martina BALEGOVÁ",
        :stav => "01",
        :funkcia => "Sudca",
        :sud_guid => "126",
        :typ_sudu => "Okresný súd",
        :asud_guid => "123",
        :kraj_sudu => "Nitriansky kraj",
        :okres_sudu => "Okres Nitra",
        :stav_zmena => "1.11.2015",
        :aktualizacia => "2015-12-08T00:00:00Z",
        :lattitude_sudu => "48.3080863",
        :longitude_sudu => "18.0830243"
      }
    )

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
    expect(employments[0].note).to be_nil

    expect(employments[1].court).to eql(Court.find_by(name: 'Krajský súd Nitra'))
    expect(employments[1].position).to eql(Judge::Position.find_by(value: 'sudca'))
    expect(employments[1].active).to eql(true)
    expect(employments[1].note).to be_nil
  end

  scenario 'updates judges from InfoSud archives and preserves their employment history', vcr: { cassette_name: 'info_sud/judges' } do
    Timecop.travel(30.minutes.ago) do
      InfoSud::Importer.import(data, repository: InfoSud::Judge)
    end

    updated_at = 1.minute.ago

    Timecop.freeze(updated_at) do
      InfoSud::Importer.import(updated_data, repository: InfoSud::Judge)
    end

    expect(Judge.where('updated_at >= ?', updated_at).size).to eql(1)

    record = InfoSud::Judge.find_by(guid: 'sudca_1508')
    judge = Judge.find_by(name: 'JUDr. Martina Balegová')

    expect(record.attributes.deep_symbolize_keys.except(:id, :created_at, :updated_at)).to eql(
      :guid => "sudca_1508",
      :data => {
        :sud => "Okresný súd Levice",
        :asud => "Krajský súd v Trenčíne",
        :guid => "sudca_1508",
        :meno => "JUDr. Martina BALEGOVÁ",
        :stav => "01",
        :funkcia => "Sudca",
        :sud_guid => "126",
        :typ_sudu => "Okresný súd",
        :asud_guid => "123",
        :kraj_sudu => "Nitriansky kraj",
        :okres_sudu => "Okres Nitra",
        :stav_zmena => "1.11.2015",
        :aktualizacia => "2015-12-08T00:00:00Z",
        :lattitude_sudu => "48.3080863",
        :longitude_sudu => "18.0830243"
      }
    )

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
    expect(employments[0].note).to be_nil

    expect(employments[1].court).to eql(Court.find_by(name: 'Krajský súd Nitra'))
    expect(employments[1].position).to eql(Judge::Position.find_by(value: 'sudca'))
    expect(employments[1].active).to eql(false)
    expect(employments[1].note).to be_nil

    expect(employments[2].court).to eql(Court.find_by(name: 'Krajský súd Trenčín'))
    expect(employments[2].position).to eql(Judge::Position.find_by(value: 'sudca'))
    expect(employments[2].active).to eql(true)
    expect(employments[2].note).to be_nil
  end
end
