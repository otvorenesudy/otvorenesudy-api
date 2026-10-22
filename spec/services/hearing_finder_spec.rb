# frozen_string_literal: true

require 'rails_helper'

# Finds the Open Courts hearing a source's hearing is: by its address, or by its court, time, file number and judges
# when the source publishes it under another address. Judges match by name, as InfoSud gives them.
RSpec.describe HearingFinder do
  let(:court) { create(:court, name: 'Okresný súd Rožňava') }
  let(:date) { '2016-01-12T09:00:00Z' }

  def mapper(**data)
    InfoSud::HearingMapper.new({ guid: 'a1', sud_nazov: 'Okresný súd Rožňava', identifikacne_cislo_spisu: '7813210471',
                                 datum_a_cas_pojednavania: date, sudca_meno: ['JUDr. Peter Pan'] }.merge(data))
  end

  def create_hearing(uri:)
    create(:hearing, uri:, court:, file_number: '7813210471', date: Time.zone.parse(date)).tap do |hearing|
      create(:judging, hearing:, judge: create(:judge, name: 'JUDr. Peter Pan'))
    end
  end

  describe '.find_by' do
    it 'finds the hearing at the address' do
      hearing = create_hearing(uri: 'https://obcan.justice.sk/infosud/-/infosud/i-detail/pojednavanie/a1')

      expect(described_class.find_by(mapper)).to eq(hearing)
    end

    it 'finds the hearing of the same court, time, file number and judges at another address' do
      hearing = create_hearing(uri: 'https://www.justice.gov.sk/old')
      create(:hearing, court:, file_number: '123', date: Time.zone.parse(date))

      expect(described_class.find_by(mapper)).to eq(hearing)
    end

    it 'finds nothing for a hearing heard by other judges' do
      create_hearing(uri: 'https://www.justice.gov.sk/old')

      expect(described_class.find_by(mapper(sudca_meno: ['JUDr. Ján Novák']))).to be_nil
    end

    it 'finds nothing for a hearing without a file number' do
      create_hearing(uri: 'https://www.justice.gov.sk/old')

      expect(described_class.find_by(mapper(identifikacne_cislo_spisu: nil))).to be_nil
    end
  end
end
