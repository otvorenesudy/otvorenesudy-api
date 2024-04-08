require 'spec_helper'
require 'obcan_justice_sk'
require_relative '../../../app/mappers/obcan_justice_sk/court_mapper'

RSpec.describe ObcanJusticeSk::CourtMapper do
  subject { ObcanJusticeSk::CourtMapper.new(data) }

  let(:data) { JSON.parse(fixture('obcan_justice_sk/mappers/court.json').read) }

  describe '#uri' do
    it 'maps uri from guid' do
      expect(subject.uri).to eql('https://obcan.justice.sk/infosud/-/infosud/reg-detail/sud/sud_102')
    end
  end

  describe '#name' do
    it 'maps name' do
      expect(subject.name).to eql('Mestský súd Bratislava I')
    end
  end

  describe '#street' do
    it 'maps street and building number' do
      expect(subject.street).to eql('Záhradnícka 10')
    end
  end

  describe '#municipality' do
    it 'maps municipality name' do
      expect(subject.municipality).to eql('Bratislava I')
    end
  end

  describe '#zipcode' do
    it 'maps zipcode' do
      expect(subject.zipcode).to eql('812 44')
    end
  end

  describe '#type' do
    it 'maps type' do
      expect(subject.type).to eql('Mestský')
    end
  end

  describe '#latitude' do
    it 'maps latitude' do
      expect(subject.latitude).to eql('48.152538')
    end
  end

  describe '#longitude' do
    it 'maps longitude' do
      expect(subject.longitude).to eql('17.122962')
    end
  end

  describe '#phone' do
    it 'maps phone' do
      expect(subject.phone).to eql('+421288810111')
    end
  end

  describe '#fax' do
    it 'maps fax number' do
      expect(subject.fax).to eql('+421288811191')
    end
  end

  describe '#media_person' do
    it 'maps media person' do
      expect(subject.media_person).to eql('JUDr. Mgr. Pavol Adamčiak')
    end
  end

  describe '#media_phone' do
    it 'maps media phone' do
      expect(subject.media_phone).to eql('+421288810285, 0903 424 263')
    end
  end

  describe '#acronym' do
    it 'maps acronym' do
      expect(subject.acronym).to eql('MSBA1')
    end
  end

  describe '#information_center_email' do
    it 'maps information center email' do
      expect(subject.information_center_email).to eql('podatelnamsba1@justice.sk')
    end
  end

  describe '#information_center_phone' do
    it 'maps information center phone' do
      expect(subject.information_center_phone).to eql('02/88 811 200')
    end
  end

  describe '#information_center_note' do
    it 'maps information center note' do
      expect(subject.information_center_note).to eql(nil)
    end
  end

  describe '#information_center_opening_hours' do
    it 'maps information center opening hours' do
      expect(subject.information_center_hours).to eql(
        [
          '8:00 - 12:00, 13:00 - 15:00',
          '8:00 - 12:00, 13:00 - 15:00',
          '8:00 - 12:00, 13:00 - 15:00',
          '8:00 - 12:00, 13:00 - 15:00',
          '8:00 - 12:00'
        ]
      )
    end
  end

  describe '#registry_center_email' do
    it 'maps registry center email' do
      expect(subject.registry_center_email).to eql('podatelnamsba1@justice.sk')
    end
  end

  describe '#registry_center_phone' do
    it 'maps registry center phone' do
      expect(subject.registry_center_phone).to eql('02/88 811 180, 02/88 811 720')
    end
  end

  describe '#registry_center_note' do
    it 'maps registry center note' do
      expect(subject.registry_center_note).to eql('Záhradnícka 10, 812 44 Bratislava')
    end
  end

  describe '#registry_center_opening_hours' do
    it 'maps registry center opening hours' do
      expect(subject.registry_center_hours).to eql(
        [
          '8:00 - 12:00, 13:00 - 15:00',
          '8:00 - 12:00, 13:00 - 15:00',
          '8:00 - 12:00, 13:00 - 15:00',
          '8:00 - 12:00, 13:00 - 15:00',
          '8:00 - 12:00'
        ]
      )
    end
  end

  describe '#business_registry_center_email' do
    it 'maps business registry center email' do
      expect(subject.business_registry_center_email).to eql(nil)
    end
  end

  describe '#business_registry_center_phone' do
    it 'maps business registry center phone' do
      expect(subject.business_registry_center_phone).to eql(nil)
    end
  end

  describe '#business_registry_center_note' do
    it 'maps business registry center note' do
      expect(subject.business_registry_center_note).to eql(nil)
    end
  end

  describe '#business_registry_center_opening_hours' do
    it 'maps business registry center opening hours' do
      expect(subject.business_registry_center_hours).to eql([])
    end
  end
end
