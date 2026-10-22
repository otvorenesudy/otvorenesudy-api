# frozen_string_literal: true

require 'rails_helper'

RSpec.describe ObcanJusticeSk::CourtMapper do
  subject(:mapper) { described_class.new(build(:obcan_justice_sk_court, id: 1, data:)) }

  let(:data) { JSON.parse(file_fixture('obcan_justice_sk/mappers/court.json').read) }

  describe '#uri' do
    it 'maps uri from guid' do
      expect(mapper.uri).to eql('https://www.justice.gov.sk/sudy-a-rozhodnutia/sudy/sud_102')
    end
  end

  describe '#name' do
    it 'maps name' do
      expect(mapper.name).to eql('Mestský súd Bratislava I')
    end
  end

  describe '#street' do
    it 'maps street and building number' do
      expect(mapper.street).to eql('Záhradnícka 10')
    end
  end

  describe '#municipality' do
    it 'maps municipality name' do
      expect(mapper.municipality).to eql('Bratislava I')
    end
  end

  describe '#zipcode' do
    it 'maps zipcode' do
      expect(mapper.zipcode).to eql('812 44')
    end
  end

  describe '#type' do
    it 'maps type' do
      expect(mapper.type).to eql('Mestský')
    end
  end

  describe '#latitude' do
    it 'maps latitude' do
      expect(mapper.latitude).to eql('48.152538')
    end
  end

  describe '#longitude' do
    it 'maps longitude' do
      expect(mapper.longitude).to eql('17.122962')
    end
  end

  describe '#phone' do
    it 'maps phone' do
      expect(mapper.phone).to eql('+421288810111')
    end
  end

  describe '#fax' do
    it 'maps fax number' do
      expect(mapper.fax).to eql('+421288811191')
    end
  end

  describe '#media_person' do
    it 'maps media person' do
      expect(mapper.media_person).to eql('JUDr. Mgr. Pavol Adamčiak')
    end
  end

  describe '#media_phone' do
    it 'maps media phone' do
      expect(mapper.media_phone).to eql('+421288810285, 0903 424 263')
    end
  end

  describe '#acronym' do
    it 'maps acronym' do
      expect(mapper.acronym).to eql('MSBA1')
    end
  end

  describe '#information_center_email' do
    it 'maps information center email' do
      expect(mapper.information_center_email).to eql('podatelnamsba1@justice.sk')
    end
  end

  describe '#information_center_phone' do
    it 'maps information center phone' do
      expect(mapper.information_center_phone).to eql('02/88 811 200')
    end
  end

  describe '#information_center_note' do
    it 'maps information center note' do
      expect(mapper.information_center_note).to be_nil
    end
  end

  describe '#information_center_opening_hours' do
    it 'maps information center opening hours' do
      expect(mapper.information_center_hours).to eql(
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
      expect(mapper.registry_center_email).to eql('podatelnamsba1@justice.sk')
    end
  end

  describe '#registry_center_phone' do
    it 'maps registry center phone' do
      expect(mapper.registry_center_phone).to eql('02/88 811 180, 02/88 811 720')
    end
  end

  describe '#registry_center_note' do
    it 'maps registry center note' do
      expect(mapper.registry_center_note).to eql('Záhradnícka 10, 812 44 Bratislava')
    end
  end

  describe '#registry_center_opening_hours' do
    it 'maps registry center opening hours' do
      expect(mapper.registry_center_hours).to eql(
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
      expect(mapper.business_registry_center_email).to be_nil
    end
  end

  describe '#business_registry_center_phone' do
    it 'maps business registry center phone' do
      expect(mapper.business_registry_center_phone).to be_nil
    end
  end

  describe '#business_registry_center_note' do
    it 'maps business registry center note' do
      expect(mapper.business_registry_center_note).to be_nil
    end
  end

  describe '#business_registry_center_opening_hours' do
    it 'maps business registry center opening hours' do
      expect(mapper.business_registry_center_hours).to eql([])
    end
  end

  context 'with a court that has a business registry center' do
    let(:data) { JSON.parse(file_fixture('obcan_justice_sk/mappers/court_with_orsr.json').read) }

    it 'maps information center note' do
      expect(mapper.information_center_note).to eq(
        "Informačné centrum:\n\nMedená 22:                  02 888 11 650 \n" \
        "Námestie Biely kríž 7:  02 888 13 200                            \n     " \
        "Účastníci konania, strany sporu a ich zástupcovia môžu požiadať o nahliadnutie do súdneho spisu " \
        "osobne v informačnom centre súdu alebo telefonicky:\n" \
        "Nám. Biely kríž, tel. čísla: 02/888 13 200, 02/888 13 201.\n\n" \
        "e-mailom na adrese:  podatelnaMSBA3@justice.sk.\n"
      )
    end

    it 'maps business registry center email' do
      expect(mapper.business_registry_center_email).to eq('podatelnamsba3@justice.sk')
    end

    it 'maps business registry center phone' do
      expect(mapper.business_registry_center_phone).to eq('+421288811600')
    end

    it 'maps business registry center note' do
      expect(mapper.business_registry_center_note).to eq(
        "Obchodný úsek MS BA III, Medená 22, 811 02 Bratislava\n\n" \
        "                                                        \nSkrátené úradné hodiny:\n" \
        "Dňa       28.03.2024        od 08:00 hod. do 12:00 hod.\n" \
        "Dňa \t23.12.2024\tod 08:00 hod. do 12:00 hod.\n" \
        "Dňa \t31.12.2024\tod 08:00 hod. do 12:00 hod.\n"
      )
    end

    it 'maps business registry center opening hours' do
      expect(mapper.business_registry_center_hours).to eq(
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

  context 'with a court that has a data protection email' do
    let(:data) { JSON.parse(file_fixture('obcan_justice_sk/mappers/court_with_data_protection.json').read) }

    it 'maps data protection email' do
      expect(mapper.data_protection_email).to eq('ochrana.osobnych.udajov.KSBB@justice.sk')
    end
  end
end
