# frozen_string_literal: true

require 'rails_helper'

# A civil or criminal hearing as obcan.justice.sk publishes it becomes an Open Courts hearing, with its parties
# anonymized: the import stores the record, which enqueues ReconcileHearingJob with it, and the job writes the hearing
# and asks otvorenesudy to reindex it.
RSpec.describe ReconcileHearingJob do
  let(:initials) { /\A[A-Z]\. [A-Z]\.\z/ }

  before { create_lookups }

  def payload(name)
    JSON.parse(file_fixture("obcan_justice_sk/mappers/#{name}.json").read)
  end

  def import_civil(data)
    perform_enqueued_jobs do
      ObcanJusticeSk::CivilHearing.import_from!(guid: data.fetch('guid'), uri: 'https://obcan.justice.sk/civil', data:)
    end
  end

  def import_criminal(data)
    perform_enqueued_jobs do
      ObcanJusticeSk::CriminalHearing.import_from!(guid: data.fetch('id'), uri: 'https://obcan.justice.sk/criminal',
                                                   data:)
    end
  end

  describe 'a civil hearing' do
    let(:court) { create(:court, name: 'Správny súd Banská Bystrica') }
    let(:judge) { create(:judge, name: 'Mgr. Denisa Slivová') }
    let(:hearing) { Hearing.sole }

    before do
      court
      judge
    end

    it 'is written with its court, judge, section, subject, form and proceeding' do
      import_civil(payload('civil_hearing'))

      expect(hearing).to have_attributes(
        uri: 'https://www.justice.gov.sk/sudy-a-rozhodnutia/sudy/pojednavania/f5c7b3ce-e9d6-44ed-adca-66b57190e542',
        case_number: 'ZA-31S/55/2018', file_number: '5018200202', date: Time.zone.parse('2019-11-13 10:20'),
        court:, judges: [judge], source_class: 'ObcanJusticeSk::CivilHearing'
      )
      expect([hearing.type.value, hearing.section.value, hearing.subject.value, hearing.form.value])
        .to eq(['Civilné', 'S', 'preskúmanie rozh. č. 100692444/2018 z 9.4.2018', 'Pojednávanie a rozhodnutie'])
      expect([hearing.proceeding.file_number, hearing.judgings.sole.judge_chair]).to eq(['5018200202', false])
    end

    it 'names its parties by initials only, and asks otvorenesudy to reindex it' do
      import_civil(payload('civil_hearing'))

      expect(hearing.proposers.pluck(:name) + hearing.opponents.pluck(:name)).to all(match(initials))
      expect(hearing.anonymized_at).to be_present
      expect(Sidekiq::Queues['probe'].pluck('args')).to eq([['Hearing', hearing.id]])
    end

    it 'is written without a subject when the record gives none' do
      import_civil(payload('civil_hearing').except('predmet'))

      expect(hearing.subject).to be_nil
    end

    it 'is held at midnight when the record gives its day alone' do
      import_civil(payload('civil_hearing').except('casPojednavania'))

      expect(hearing.date).to eq(Time.utc(2019, 11, 13))
    end

    it 'keeps the court and the case number it came from' do
      create(:court, name: 'Okresný súd Nitra')
      topolcany = create(:court, name: 'Okresný súd Topoľčany')
      judge = create(:judge, source_class: 'ObcanJusticeSk::Judge',
                             source_class_id: create(:obcan_justice_sk_judge, guid: 'sudca_1122').id)

      import_civil(payload('civil_hearing_with_original_court'))

      expect(hearing).to have_attributes(original_court: topolcany, original_case_number: '10P/42/2023', room: '71/1')
      expect(hearing.judges).to eq([judge])
    end

    it 'updates the hearing otvorenesudy holds under another address, of the same court, time, file number and judge' do
      existing = create(:hearing, uri: 'https://www.justice.gov.sk/old', court:, file_number: '5018200202',
                                  date: Time.zone.parse('2019-11-13 10:20'))
      create(:judging, hearing: existing, judge:)

      import_civil(payload('civil_hearing'))

      expect(Hearing.pluck(:id, :case_number)).to eq([[existing.id, 'ZA-31S/55/2018']])
    end

    it 'adds a hearing of the same court, time and file number that another judge heard' do
      other = create(:hearing, uri: 'https://www.justice.gov.sk/old', court:, file_number: '5018200202',
                               date: Time.zone.parse('2019-11-13 10:20'))
      create(:judging, hearing: other, judge: create(:judge, name: 'JUDr. Ján Novák'))

      import_civil(payload('civil_hearing'))

      expect(Hearing.where.not(id: other.id).sole.case_number).to eq('ZA-31S/55/2018')
    end

    it 'is updated, not added again, when the record changes, with its parties replaced' do
      import_civil(payload('civil_hearing'))
      import_civil(payload('civil_hearing').merge('miestnost' => '12', 'navrhovatelia' => []))

      expect(Hearing.sole).to have_attributes(room: '12')
      expect([hearing.proposers.count, hearing.opponents.count]).to eq([0, 1])
    end
  end

  describe 'a criminal hearing' do
    it 'is written with its judge, its defendants by initials, and whether one judge sits' do
      create(:court, name: 'Okresný súd Nové Zámky')
      judge = create(:judge, name: 'JUDr. Vladimír Tamaškovič')

      import_criminal(payload('criminal_hearing'))

      hearing = Hearing.sole

      expect(hearing).to have_attributes(
        file_number: '4424010012', case_number: '4Tcud/1/2024', date: Time.zone.parse('2024-05-02 08:30'),
        selfjudge: false, special_type: 'Trestné pojednávanie', room: '33', judges: [judge]
      )
      expect(hearing.type.value).to eq('Trestné')
      expect(hearing.defendants.pluck(:name)).to all(match(initials))
    end

    it 'has its judge chairing at the specialized criminal court' do
      create(:court, name: 'Špecializovaný trestný súd')
      judge = create(:judge, name: 'JUDr. Jozef Pikna')

      import_criminal(payload('special_criminal_hearing'))

      expect(Hearing.sole.type.value).to eq('Špecializovaného trestného súdu')
      expect(Judging.pluck(:judge_id, :judge_chair)).to eq([[judge.id, true]])
    end
  end
end
