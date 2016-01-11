require 'rails_helper'

RSpec.feature 'Import Hearings' do
  let(:data) { fixture('info_sud/hearings.json').read }
  let!(:source) { create(:source, :justice_gov_sk) }
  let!(:judge) { create(:judge, name: 'JUDr. Margaréta Hlaváčková') }

  before :each do
    create(:hearing_type, value: 'Trestné')
    create(:hearing_type, value: 'Civilné')
    create(:hearing_type, value: 'Špecializovaného trestného súdu')

    create(:court, name: 'Okresný súd Košice I')
  end

  scenario 'imports hearings from InfoSud archives' do
    pending

    InfoSud::Importer.import(data, repository: InfoSud::Hearing)

    expect(InfoSud::Hearing.count).to eql(2)
    expect(Hearing.count).to eql(2)

    hearing = Hearing.find_by(uri: 'https://obcan.justice.sk/infosud/-/infosud/i-detail/pojednavanie/94fed4fd-af4a-42c3-8c21-788358207927')
    court = Court.find_by(name: 'Okresný súd Košice I')
    type = Hearing::Type.find_by(value: 'Trestné')
    section = Hearing::Section.find_by(value: 'T')
    subject = Hearing::Subject.find_by(value: '4Pv 461/14 - § 189 ods. 1 Tr. zák.')
    form = Hearing::Form.find_by(value: 'Hlavné pojednávanie s rozhodnutím')
    proceeding = Proceeding.find_by(file_number: '7115010154')

    expect(hearing.attributes.symbolize_keys.except(:id, :created_at, :updated_at)).to eql(
      uri: 'https://obcan.justice.sk/infosud/-/infosud/i-detail/pojednavanie/94fed4fd-af4a-42c3-8c21-788358207927',
      source_id: source.id,
      case_number: '3T/9/2015',
      file_number: '7115010154',
      date: Time.parse('2015-12-07T12:30:00Z'),
      room: '135',
      commencement_date: nil,
      selfjudge: true,
      note: nil,
      anonymized: false,
      special_type: nil,

      court_id: court.id,
      hearing_type_id: type.id,
      hearing_section_id: section.id,
      hearing_subject_id: subject.id,
      hearing_form_id: form.id,
      proceeding_id: proceeding.id
    )

    expect(hearing.proposers.to_a).to be_empty
    expect(hearing.opponents.to_a).to be_empty
    expect(hearing.defendants.pluck(:name)).to eql(['Peter Pan'])
    expect(hearing.judges).to eql([judge])
  end

  scenario 'updated hearings from InfoSud archives' do
  end
end
