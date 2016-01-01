require 'rails_helper'

RSpec.describe InfoSud::CourtMapper do
  subject { InfoSud::CourtMapper.new(court) }

  let(:court) { double(:court, data: data) }
  let(:data) {
    {
      "ico"=>"00039471",
      "addr"=>{"Country"=>"703", "PostalCode"=>"81244", "StreetName"=>"Záhradnícka", "Municipality"=>"Bratislava I", "BuildingNumber"=>"10"},
      "guid"=>"sud_102",
      "kraj"=>"Bratislavský kraj",
      "orsr"=> {
        "tel"=>[{"tel_type"=>"label.codelist.tel_type", "tel_number"=>"02/501 18 340, 02/501 18 356, 02/501 18 181, 02/501 18 421"}],
        "note"=>"prestávka v práci PO - ŠT: 12:00 - 13:00",
        "opening_hours"=>["8:00 - 15:00", "", "", "8:00 - 15:00", "", "", "8:00 - 15:00", "", "", "8:00 - 15:00", "", "", "8:00 - 12:00", "", "", "", "", "", "", "", ""]
      },
      "nazov"=>"Okresný súd Bratislava I",
      "okres"=>"Okres Bratislava I",
      "zapisy"=>[],
      "address"=>"Záhradnícka 10, Bratislava I",
      "skratka"=>"OSBA1",
      "predseda"=>{"sudcovia"=>[{"id"=>"561", "name"=>"JUDr. Eva FULCOVÁ"}]},
      "typ_sudu"=>"Okresný súd",
      "lattitude"=>"48.152538",
      "longitude"=>"17.122962",
      "media_tel"=>[{"tel_type"=>"label.codelist.tel_type", "tel_number"=>"0903 424 263, 02/50118417"}],
      "podatelna"=> {
        "tel"=>[{"tel_type"=>"label.codelist.tel_type", "tel_number"=>"02/88811180, fax. 02/88811192"}],
       "opening_hours"=>["8:00 - 15:30", "", "", "8:00 - 15:30", "", "", "8:00 - 15:30", "", "", "8:00 - 15:30", "", "", "8:00 - 15:00", "", "", "", "", "", "", "", ""],
       "internetAddress"=>{"email"=>"podatelnaosba1@justice.sk"}
      },
      "podpredseda"=>{"sudcovia"=>[{"id"=>"1767", "name"=>"Mgr. Miriam PLAVČÁKOVÁ"}]},
      "aktualizacia"=>"2015-12-09T00:00:00Z",
      "info_centrum"=> {
        "tel"=>[{"tel_type"=>"label.codelist.tel_type", "tel_number"=>"02/88811200"}],
       "opening_hours"=>["8:00 - 15:00", "", "", "8:00 - 15:00", "", "", "8:00 - 15:00", "", "", "8:00 - 15:00", "", "", "8:00 - 14:00", "", "", "", "", "", "", "", ""],
       "internetAddress"=>{"email"=>"podatelnaosba1@justice.sk"}
      },
      "opening_hours"=>nil,
      "internet_address"=>nil
    }
  }

  describe '#uri' do
    it 'maps uri from guid' do
      expect(subject.uri).to eql('https://obcan.justice.sk/infosud/-/infosud/reg-detail/sud/sud_102')
    end
  end

  describe '#name' do
    it 'maps name' do
      expect(subject.name).to eql('Okresný súd Bratislava I')
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
      expect(subject.zipcode).to eql('81244')
    end
  end

  describe '#type' do
    it 'maps type' do
      expect(subject.type).to eql('Okresný')
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
      # TODO
      expect(subject.phone).to eql(nil)
    end
  end

  describe '#fax' do
    it 'maps fax number' do
      # TODO
      expect(subject.fax).to eql(nil)
    end
  end

  describe '#media_person' do
    it 'maps media person' do
      # TODO
      expect(subject.media_person).to eql(nil)
    end
  end

  describe '#media_phone' do
    it 'maps media phone' do
      expect(subject.media_phone).to eql('0903 424 263, 02/50 118 417')
    end
  end

  describe '#acronym' do
    it 'maps acronym' do
      expect(subject.acronym).to eql('OSBA1')
    end
  end

  describe '#information_center_email' do
    it 'maps information center email' do
      expect(subject.information_center_email).to eql('podatelnaosba1@justice.sk')
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
      expect(subject.information_center_hours).to eql([
         "8:00 - 15:00",
         "8:00 - 15:00",
         "8:00 - 15:00",
         "8:00 - 15:00",
         "8:00 - 14:00"
       ])
    end
  end

  describe '#registry_center_email' do
    it 'maps registry center email' do
      expect(subject.registry_center_email).to eql('podatelnaosba1@justice.sk')
    end
  end

  describe '#registry_center_phone' do
    it 'maps registry center phone' do
      expect(subject.registry_center_phone).to eql('02/88 811 180, fax 02/88 811 192')
    end
  end

  describe '#registry_center_note' do
    it 'maps registry center note' do
      expect(subject.registry_center_note).to eql(nil)
    end
  end

  describe '#registry_center_opening_hours' do
    it 'maps registry center opening hours' do
      expect(subject.registry_center_hours).to eql([
         "8:00 - 15:30",
         "8:00 - 15:30",
         "8:00 - 15:30",
         "8:00 - 15:30",
         "8:00 - 15:00"
       ])
    end
  end

  describe '#business_registry_center_email' do
    it 'maps business registry center email' do
      expect(subject.business_registry_center_email).to eql(nil)
    end
  end

  describe '#business_registry_center_phone' do
    it 'maps business registry center phone' do
      expect(subject.business_registry_center_phone).to eql('02/50 118 340, 02/50 118 356, 02/50 118 181, 02/50 118 421')
    end
  end

  describe '#business_registry_center_note' do
    it 'maps business registry center note' do
      expect(subject.business_registry_center_note).to eql('prestávka v práci PO - ŠT: 12:00 - 13:00')
    end
  end

  describe '#business_registry_center_opening_hours' do
    it 'maps business registry center opening hours' do
      expect(subject.business_registry_center_hours).to eql([
         "8:00 - 15:00",
         "8:00 - 15:00",
         "8:00 - 15:00",
         "8:00 - 15:00",
         "8:00 - 12:00"
       ])
    end
  end
end
