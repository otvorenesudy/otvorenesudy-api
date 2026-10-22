# frozen_string_literal: true

require 'rails_helper'

# A court as obcan.justice.sk publishes it becomes an Open Courts court: the import stores the record, which enqueues
# ReconcileCourtJob with it, and the job writes the court and asks otvorenesudy to reindex it.
RSpec.describe ReconcileCourtJob do
  let(:court) { Court.find_by!(name: 'Mestský súd Bratislava I') }

  before { create_lookups }

  def payload(name)
    JSON.parse(file_fixture("obcan_justice_sk/mappers/#{name}.json").read)
  end

  def import(data)
    guid = data.fetch('registreGuid')

    perform_enqueued_jobs do
      ObcanJusticeSk::Court.import_from!(guid:, uri: "https://obcan.justice.sk/sud/#{guid}", data:)
    end
  end

  it 'writes the court from the record, with its type, seat and contacts' do
    import(payload('court'))

    expect(court).to have_attributes(
      uri: 'https://www.justice.gov.sk/sudy-a-rozhodnutia/sudy/sud_102', street: 'Záhradnícka 10',
      phone: '+421288810111', fax: '+421288811191', media_person: 'JUDr. Mgr. Pavol Adamčiak',
      media_phone: '+421288810285, 0903 424 263', acronym: 'MSBA1', latitude: BigDecimal('48.152538'),
      longitude: BigDecimal('17.122962'), source_class: 'ObcanJusticeSk::Court',
      source_class_id: ObcanJusticeSk::Court.find_by!(guid: 'sud_102').id
    )
    expect([court.type.value, court.source.module]).to eq(%w[Mestský JusticeGovSk])
    expect([court.municipality.name, court.municipality.zipcode]).to eq(['Bratislava I', '812 44'])
  end

  it 'asks otvorenesudy to reindex the court' do
    import(payload('court'))

    expect(Sidekiq::Queues['probe'].map { |job| job.values_at('class', 'args') })
      .to eq([['UpdateRepositoryJob', ['Court', court.id]]])
  end

  it 'writes the information center and the registry with their hours, and no commercial registry the record lacks' do
    import(payload('court'))

    hours = (['8:00 - 12:00, 13:00 - 15:00'] * 4) + ['8:00 - 12:00']

    expect(court.information_center).to have_attributes(
      email: 'podatelnamsba1@justice.sk', phone: '02/88 811 200', note: nil,
      hours_monday: hours[0], hours_tuesday: hours[1], hours_wednesday: hours[2], hours_thursday: hours[3],
      hours_friday: hours[4]
    )
    expect(court.registry_center).to have_attributes(
      email: 'podatelnamsba1@justice.sk', phone: '02/88 811 180, 02/88 811 720',
      note: 'Záhradnícka 10, 812 44 Bratislava', hours_friday: '8:00 - 12:00'
    )
    expect(court.business_registry_center).to be_nil
  end

  it 'writes the commercial registry and the other contact places of a court that has them' do
    import(payload('court_with_orsr'))

    court = Court.find_by!(source_class_id: ObcanJusticeSk::Court.sole.id)

    expect(court.business_registry_center).to have_attributes(
      email: 'podatelnamsba3@justice.sk', phone: '+421288811600', hours_friday: '8:00 - 12:00'
    )
    expect(JSON.parse(court.other_contacts_json)).to all(include('name'))
  end

  it 'writes the e-mail for personal data protection' do
    import(payload('court_with_data_protection'))

    expect(Court.sole.data_protection_email).to eq('ochrana.osobnych.udajov.KSBB@justice.sk')
  end

  it 'updates the same court and its offices when the record changes' do
    import(payload('court'))
    import(payload('court').merge('adresaString' => 'Záhradnícka 12, 81244 Bratislava I, Slovenská republika'))

    expect(Court.where(name: 'Mestský súd Bratislava I').pluck(:street)).to eq(['Záhradnícka 12'])
    expect(Court::Office.where(court:).count).to eq(2)
  end

  it 'leaves out the offices for which the record gives nothing' do
    data = payload('court').merge(
      'infoCentrum' => { 'otvaracieHodiny' => [] }, 'podatelna' => { 'otvaracieHodiny' => [], 'telKontakty' => [] }
    )

    import(data)

    expect([court.information_center, court.registry_center, court.business_registry_center]).to all(be_nil)
  end
end
