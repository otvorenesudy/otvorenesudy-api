require 'rails_helper'

RSpec.feature 'Import Courts' do
  # TODO refactor main application to use InfoSud namespace instead of JusticeGovSk as base
  let!(:source) { create(:source, :justice_gov_sk) }
  let!(:office_types) {
    [
      create(:court_office_type, value: 'Informačné centrum'),
      create(:court_office_type, value: 'Podateľna'),
      create(:court_office_type, value: 'Informačné stredisko obchodného registra')
    ]
  }

  before :each do
    ActiveJob::Base.queue_adapter = :test

    create(:court_type, value: 'Okresný')
    create(:court_type, value: 'Krajský')
    create(:court_type, value: 'Najvyšší')
    create(:court_type, value: 'Ústavný')
    create(:court_type, value: 'Špecializovaný')
  end

  after :each do
    ActiveJob::Base.queue_adapter = :inline
  end

  scenario 'imports courts from InfoSud archives', vcr: { cassette_name: 'info_sud/courts' } do
    perform_enqueued_jobs do
      InfoSud.import_courts
    end

    expect(InfoSud::Court.count).to eql(64)
    expect(Court.count).to eql(64)

    record = InfoSud::Court.find_by(guid: 'sud_102')
    court = Court.find_by(name: 'Okresný súd Bratislava I')

    expect(record.attributes.deep_symbolize_keys.except(:id, :created_at, :updated_at)).to eql(
      :guid => "sud_102",
      :data => {
        :ico => "00039471",
        :addr => {
          :Country => "703",
          :PostalCode => "81244",
          :StreetName => "Záhradnícka",
          :Municipality => "Bratislava I",
          :BuildingNumber => "10"
        },
        :guid => "sud_102",
        :kraj => "Bratislavský kraj",
        :orsr => {
          :tel => [
            {
              :tel_type => "label.codelist.tel_type",
              :tel_number => "02/501 18 340, 02/501 18 356, 02/501 18 181, 02/501 18 421"
            }
          ],
          :note => "prestávka v práci PO - ŠT: 12:00 - 13:00",
          :opening_hours => [
            "8:00 - 15:00",
            "",
            "",
            "8:00 - 15:00",
            "",
            "",
            "8:00 - 15:00",
            "",
            "",
            "8:00 - 15:00",
            "",
            "",
            "8:00 - 12:00",
            "",
            "",
            "",
            "",
            "",
            "",
            "",
            ""
          ]
        },
        :nazov => "Okresný súd Bratislava I",
        :okres => "Okres Bratislava I",
        :zapisy => [],
        :address => "Záhradnícka 10, Bratislava I",
        :skratka => "OSBA1",
        :predseda => {
          :sudcovia => [
            {
              :id => "561",
              :name => "JUDr. Eva FULCOVÁ"
            }
          ]
        },
        :typ_sudu => "Okresný súd",
        :lattitude => "48.152538",
        :longitude => "17.122962",
        :media_tel => [
          {
            :tel_type => "label.codelist.tel_type",
            :tel_number => "0903 424 263, 02/50118417"
          }
        ],
        :podatelna => {
          :tel => [
            {
              :tel_type => "label.codelist.tel_type",
              :tel_number => "02/88811180, fax. 02/88811192"
            }
          ],
          :opening_hours => [
            "8:00 - 15:30",
            "",
            "",
            "8:00 - 15:30",
            "",
            "",
            "8:00 - 15:30",
            "",
            "",
            "8:00 - 15:30",
            "",
            "",
            "8:00 - 15:00",
            "",
            "",
            "",
            "",
            "",
            "",
            "",
            ""
          ],
          :internetAddress => {
            :email => "podatelnaosba1@justice.sk"
          }
        },
        :podpredseda => {
          :sudcovia => [
            {
              :id => "1767",
              :name => "Mgr. Miriam PLAVČÁKOVÁ"
            }
          ]
        },
        :aktualizacia => "2015-12-09T00:00:00Z",
        :info_centrum => {
          :tel => [
            {
              :tel_type => "label.codelist.tel_type",
              :tel_number => "02/88811200"
            }
          ],
          :opening_hours => [
            "8:00 - 15:00",
            "",
            "",
            "8:00 - 15:00",
            "",
            "",
            "8:00 - 15:00",
            "",
            "",
            "8:00 - 15:00",
            "",
            "",
            "8:00 - 14:00",
            "",
            "",
            "",
            "",
            "",
            "",
            "",
            ""
          ],
          :internetAddress => {
            :email => "podatelnaosba1@justice.sk"
          }
        },
        :opening_hours => nil,
        :internet_address => nil
      }
    )

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
      :phone => nil,
      :fax => nil,
      :media_person => nil,
      :media_person_unprocessed => nil,
      :media_phone => "0903 424 263, 02/50 118 417",
      :information_center_id => information_center.id,
      :registry_center_id => registry_center.id,
      :business_registry_center_id => business_registry_center.id,
      :acronym => 'OSBA1'
    )

    expect(court.latitude.to_f).to eql(48.152538)
    expect(court.longitude.to_f).to eql(17.122962)

    expect(municipality.zipcode).to eql('81244')

    # TODO check offices' hours
  end

  scenario 'updates courts from InfoSud archives', vcr: { cassette_name: 'info_sud/courts' } do
    Timecop.travel(30.minutes.ago) do
      perform_enqueued_jobs do
        InfoSud.import_courts
      end
    end

    updated_at = Time.now
    updated_data = fixture('info_sud/updated_courts.json').read

    Timecop.freeze(updated_at) do
      perform_enqueued_jobs do
        InfoSud::Importer.import(updated_data, repository: InfoSud::Court)
      end
    end

    courts = Court.where('updated_at >= ?', updated_at)

    expect(courts.size).to eql(1)

    record = InfoSud::Court.find_by(guid: 'sud_102')
    court = courts.first

    expect(record.attributes.deep_symbolize_keys.except(:id, :created_at, :updated_at)).to eql(
      :guid => "sud_102",
      :data => {
        :ico => "00039471",
        :addr => {
          :Country => "703",
          :PostalCode => "12345",
          :StreetName => "Záhradnícka",
          :Municipality => "Bratislava I",
          :BuildingNumber => "10"
        },
        :guid => "sud_102",
        :kraj => "Bratislavský kraj",
        :orsr => {
          :tel => [
            {
              :tel_type => "label.codelist.tel_type",
              :tel_number => "02/501 18 340, 02/501 18 356, 02/501 18 181, 02/501 18 421"
            }
          ],
          :note => "prestávka v práci PO - ŠT: 12:00 - 13:00",
          :opening_hours => [
            "8:00 - 15:00",
            "",
            "",
            "8:00 - 15:00",
            "",
            "",
            "8:00 - 15:00",
            "",
            "",
            "8:00 - 15:00",
            "",
            "",
            "8:00 - 12:00",
            "",
            "",
            "",
            "",
            "",
            "",
            "",
            ""
          ]
        },
        :nazov => "Okresný súd Bratislava I",
        :okres => "Okres Bratislava I",
        :zapisy => [],
        :address => "Záhradnícka 10, Bratislava I",
        :skratka => "OSBA1",
        :predseda => {
          :sudcovia => [
            {
              :id => "561",
              :name => "JUDr. Eva FULCOVÁ"
            }
          ]
        },
        :typ_sudu => "Okresný súd",
        :lattitude => "48.152538",
        :longitude => "18.122962",
        :media_tel => [
          {
            :tel_type => "label.codelist.tel_type",
            :tel_number => "0903 424 263, 02/50118417"
          }
        ],
        :podatelna => {
          :tel => [
            {
              :tel_type => "label.codelist.tel_type",
              :tel_number => "02/88811180, fax. 02/88811192"
            }
          ],
          :opening_hours => [
            "8:00 - 15:30",
            "",
            "",
            "8:00 - 15:30",
            "",
            "",
            "8:00 - 15:30",
            "",
            "",
            "8:00 - 15:30",
            "",
            "",
            "8:00 - 15:00",
            "",
            "",
            "",
            "",
            "",
            "",
            "",
            ""
          ],
          :internetAddress => {
            :email => "podatelnaosba1@justice.sk"
          }
        },
        :podpredseda => {
          :sudcovia => [
            {
              :id => "1767",
              :name => "Mgr. Miriam PLAVČÁKOVÁ"
            }
          ]
        },
        :aktualizacia => "2015-12-09T00:00:00Z",
        :info_centrum => {
          :tel => [
            {
              :tel_type => "label.codelist.tel_type",
              :tel_number => "02/88811200"
            }
          ],
          :opening_hours => [
            "8:00 - 15:00",
            "",
            "",
            "8:00 - 15:00",
            "",
            "",
            "8:00 - 15:00",
            "",
            "",
            "8:00 - 15:00",
            "",
            "",
            "8:00 - 14:00",
            "",
            "",
            "",
            "",
            "",
            "",
            "",
            ""
          ],
          :internetAddress => {
            :email => "podatelnaosba1@justice.sk"
          }
        },
        :opening_hours => nil,
        :internet_address => nil
      }
    )


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
      :phone => nil,
      :fax => nil,
      :media_person => nil,
      :media_person_unprocessed => nil,
      :media_phone => "0903 424 263, 02/50 118 417",
      :information_center_id => information_center.id,
      :registry_center_id => registry_center.id,
      :business_registry_center_id => business_registry_center.id,
      :acronym => 'OSBA1'
    )

    expect(court.latitude.to_f).to eql(48.152538)
    expect(court.longitude.to_f).to eql(18.122962)

    expect(municipality.zipcode).to eql('12345')

    # TODO check update on offices
  end
end
