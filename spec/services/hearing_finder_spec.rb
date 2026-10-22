# frozen_string_literal: true

require 'rails_helper'

# Finds the Open Courts hearing a source's hearing is: by its address, or by its court, time, file number and judges
# when the source publishes it under another address. The mappers give the judges as Open Courts judges.
RSpec.describe HearingFinder do
  let(:court) { create(:court, name: 'Okresný súd Rožňava') }
  let(:judge) { create(:judge, name: 'JUDr. Peter Pan') }

  def mapper(**data)
    hearing = {
      guid: 'a1', sud: { nazov: 'Okresný súd Rožňava' }, identifikacneCislo: '7813210471',
      datumPojednavania: '12.01.2016', casPojednavania: '10:00',
      sudca: [{ meno: 'JUDr. Peter Pan', registreGuid: 'null' }]
    }

    ObcanJusticeSk::CivilHearingMapper.new(build(:obcan_justice_sk_civil_hearing, data: hearing.merge(data).as_json))
  end

  def create_hearing(uri:)
    create(:hearing, uri:, court:, file_number: '7813210471',
                     date: Time.zone.parse('2016-01-12 10:00')).tap do |hearing|
      create(:judging, hearing:, judge:)
    end
  end

  describe '.find_by' do
    it 'finds the hearing at the address' do
      hearing = create_hearing(uri: 'https://www.justice.gov.sk/sudy-a-rozhodnutia/sudy/pojednavania/a1')

      expect(described_class.find_by(mapper)).to eq(hearing)
    end

    it 'finds the hearing of the same court, time, file number and judges at another address' do
      hearing = create_hearing(uri: 'https://www.justice.gov.sk/old')
      create(:hearing, court:, file_number: '123', date: Time.zone.parse('2016-01-12 10:00'))

      expect(described_class.find_by(mapper)).to eq(hearing)
    end

    it 'finds nothing for a hearing heard by other judges' do
      create_hearing(uri: 'https://www.justice.gov.sk/old')
      create(:judge, name: 'JUDr. Ján Novák')

      expect(described_class.find_by(mapper(sudca: [{ meno: 'JUDr. Ján Novák', registreGuid: 'null' }]))).to be_nil
    end

    it 'finds nothing for a hearing without a file number' do
      create_hearing(uri: 'https://www.justice.gov.sk/old')

      expect(described_class.find_by(mapper(identifikacneCislo: nil))).to be_nil
    end
  end
end
