require 'rails_helper'

RSpec.feature 'Import Courts' do
  # TODO refactor main application to use InfoSud namespace instead of JusticeGovSk as base
  let!(:source) { create(:source, :justice_gov_sk) }
  let!(:office_types) {
    [
      create(:court_office_type, value: 'Informačné centrum'),
      create(:court_office_type, value: 'Podateľňa'),
      create(:court_office_type, value: 'Informačné stredisko obchodného registra')
    ]
  }

  before :each do
    create(:court_type, value: 'Okresný')
    create(:court_type, value: 'Krajský')
    create(:court_type, value: 'Najvyšší')
    create(:court_type, value: 'Ústavný')
    create(:court_type, value: 'Špecializovaný')
  end

  scenario 'imports courts from InfoSud archives', vcr: { cassette_name: 'info_sud/courts' } do
    InfoSud.import_courts

    expect(InfoSud::Court.count).to eql(64)
    expect(Court.count).to eql(64)

    court = Court.find_by(name: 'Okresný súd Bratislava I')

    type = Court::Type.find_by(value: 'Okresný')
    municipality = Municipality.find_by(name: 'Bratislava I')
    information_center = Court::Office.find_by(court: court, type: office_types[0])
    registry_center = Court::Office.find_by(court: court, type: office_types[1])
    business_registry_center = Court::Office.find_by(court: court, type: office_types[2])

    expect(court.attributes.symbolize_keys.except(:id, :created_at, :updated_at, :latitude, :longitude)).to eql(
      :uri => "https://obcan.justice.sk/infosud/-/infosud/reg-detail/sud/sud_102",
      :source_id => source.id,
      :court_type_id => type.id,
      :court_jurisdiction_id => nil,
      :municipality_id => municipality.id,
      :name => "Okresný súd Bratislava I",
      :street => "Záhradnícka 10",
      :phone => '+421288810111',
      :fax => '+421288811191',
      :media_person => 'Mgr. Pavol Adamčiak',
      :media_person_unprocessed => nil,
      :media_phone => "0903 424 263, 02/50 118 417",
      :information_center_id => information_center.id,
      :registry_center_id => registry_center.id,
      :business_registry_center_id => business_registry_center.id,
      :acronym => 'OSBA1'
    )

    expect(court.latitude.to_f).to eql(48.152538)
    expect(court.longitude.to_f).to eql(17.122962)

    expect(municipality.zipcode).to eql('812 44')

    # TODO check offices' hours
  end

  scenario 'updates courts from InfoSud archives', vcr: { cassette_name: 'info_sud/courts' } do
    Timecop.travel(30.minutes.ago) do
      InfoSud.import_courts
    end

    updated_at = Time.now
    updated_data = fixture('info_sud/updated_courts.json').read

    Timecop.freeze(updated_at) do
      InfoSud::Importer.import(updated_data, repository: InfoSud::Court)
    end

    courts = Court.where('updated_at >= ?', updated_at)

    expect(courts.size).to eql(1)

    court = courts.first

    type = Court::Type.find_by(value: 'Okresný')
    municipality = Municipality.find_by(name: 'Bratislava I')
    information_center = Court::Office.find_by(court: court, type: office_types[0])
    registry_center = Court::Office.find_by(court: court, type: office_types[1])
    business_registry_center = Court::Office.find_by(court: court, type: office_types[2])

    expect(court.attributes.symbolize_keys.except(:id, :created_at, :updated_at, :latitude, :longitude)).to eql(
      :uri => "https://obcan.justice.sk/infosud/-/infosud/reg-detail/sud/sud_102",
      :source_id => source.id,
      :court_type_id => type.id,
      :court_jurisdiction_id => nil,
      :municipality_id => municipality.id,
      :name => "Okresný súd Bratislava I",
      :street => "Záhradnícka 10",
      :phone => '+421288810111',
      :fax => '+421288811191',
      :media_person => 'Mgr. Pavol Adamčiak',
      :media_person_unprocessed => nil,
      :media_phone => "0903 424 263, 02/50 118 417",
      :information_center_id => information_center.id,
      :registry_center_id => registry_center.id,
      :business_registry_center_id => business_registry_center.id,
      :acronym => 'OSBA1'
    )

    expect(court.latitude.to_f).to eql(48.152538)
    expect(court.longitude.to_f).to eql(18.122962)

    expect(municipality.zipcode).to eql('123 45')

    # TODO check update on offices
  end
end
