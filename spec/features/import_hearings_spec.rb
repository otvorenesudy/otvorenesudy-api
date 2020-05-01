require 'rails_helper'

RSpec.feature 'Import Hearings' do
  context 'from InfoSud archives' do
    let(:data) { fixture('info_sud/hearings.json').read }
    let(:updated_data) { fixture('info_sud/updated_hearings.json').read }
    let!(:source) { create(:source, :justice_gov_sk) }
    let!(:judges) {[
      create(:judge, name: 'JUDr. Margaréta Hlaváčková'),
      create(:judge, name: 'JUDr. Petra Hlaváčková')
    ]}

    before :each do
      create(:hearing_type, value: 'Trestné')
      create(:hearing_type, value: 'Civilné')
      create(:hearing_type, value: 'Špecializovaného trestného súdu')

      create(:court, name: 'Okresný súd Košice I')
      create(:court, name: 'Okresný súd Nitra')
      create(:court, name: 'Okresný súd Trnava')
    end

    scenario 'imports hearings' do
      created_at = Time.zone.now

      Timecop.freeze(created_at) do
        InfoSud::Importer.import(data, repository: InfoSud::Hearing)
      end

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
        date: Time.parse('2015-12-07T12:30:00Z').in_time_zone,
        room: '135',
        commencement_date: nil,
        selfjudge: true,
        note: nil,
        anonymized_at: created_at,
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
      expect(hearing.defendants.count).to eql(1)
      expect(hearing.defendants.pluck(:name).first).to match(/\A\w\. \w\.\z/)
      expect(hearing.judges.to_a).to eql([judges[0]])
    end

    scenario 'updates hearings' do
      Timecop.travel(30.minutes.ago) do
        InfoSud::Importer.import(data, repository: InfoSud::Hearing)
      end

      updated_at = Time.now

      Timecop.freeze(updated_at) do
        InfoSud::Importer.import(updated_data, repository: InfoSud::Hearing)
      end

      hearings = Hearing.where('updated_at >= ?', updated_at)

      expect(hearings.size).to eql(1)

      hearing = hearings.first
      court = Court.find_by(name: 'Okresný súd Nitra')
      type = Hearing::Type.find_by(value: 'Civilné')
      section = Hearing::Section.find_by(value: 'C')
      subject = Hearing::Subject.find_by(value: '4Pv 461/14 - § 189 ods. 1 Tr. zák.')
      form = Hearing::Form.find_by(value: 'Hlavné pojednávanie s rozhodnutím')
      proceeding = Proceeding.find_by(file_number: '123456789')

      expect(hearing.attributes.symbolize_keys.except(:id, :created_at, :updated_at)).to eql(
        uri: 'https://obcan.justice.sk/infosud/-/infosud/i-detail/pojednavanie/94fed4fd-af4a-42c3-8c21-788358207927',
        source_id: source.id,
        case_number: '3T/9/2015',
        file_number: '123456789',
        date: Time.parse('2015-12-07T12:30:00Z').in_time_zone,
        room: '135',
        commencement_date: nil,
        selfjudge: true,
        note: nil,
        anonymized_at: updated_at,
        special_type: nil,

        court_id: court.id,
        hearing_type_id: type.id,
        hearing_section_id: section.id,
        hearing_subject_id: subject.id,
        hearing_form_id: form.id,
        proceeding_id: proceeding.id
      )

      expect(hearing.proposers.count).to eql(1)
      expect(hearing.proposers.pluck(:name).first).to match(/\A\w\. \w\.\z/)

      expect(hearing.opponents.count).to eql(1)
      expect(hearing.opponents.pluck(:name).first).to match(/\A\w\. \w\.\z/)

      expect(hearing.defendants.to_a).to be_empty
      expect(hearing.judges.to_a).to eql([judges[1]])
    end
  end
end
