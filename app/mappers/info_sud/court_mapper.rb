module InfoSud
  class CourtMapper
    def initialize(court)
      @court = court
      @data = court.data.deep_symbolize_keys
    end

    def name
      @data[:nazov]
    end

    def street
      "#{@data[:addr][:StreetName]} #{@data[:addr][:BuildingNumber]}"
    end

    def municipality
      @data[:addr][:Municipality]
    end

    def zipcode
      @data[:addr][:PostalCode]
    end

    def type
      @data[:typ_sudu].split(' ').first
    end

    def latitude
      @data[:lattitude]
    end

    def longitude
      @data[:longitude]
    end

    def phone
      # TODO
    end

    def fax
      # TODO
    end

    def media_person
      # TODO
    end

    def media_phone
      map_phones(@data[:media_tel])
    end

    def information_center_email
      @data[:info_centrum].fetch([:internetAddress], {})[:email]
    end

    def information_center_phone
      map_phones(@data[:info_centrum][:tel])
    end

    def information_center_hours
      map_office_hours(@data[:info_centrum][:opening_hours])
    end

    def information_center_note
      @data[:info_centrum][:note]
    end

    def registry_center_email
      @data[:podatelna].fetch([:internetAddress], {})[:email]
    end

    def registry_center_phone
      map_phones(@data[:podatelna][:tel])
    end

    def registry_center_hours
      map_office_hours(@data[:podatelna][:opening_hours])
    end

    def registry_center_note
      @data[:podatelna][:note]
    end

    def business_registry_center_email
      @data[:orsr].fetch([:internetAddress], {})[:email]
    end

    def business_registry_center_phone
      map_phones(@data[:orsr][:tel])
    end

    def business_registry_center_hours
      map_office_hours(@data[:orsr][:opening_hours])
    end

    def business_registry_center_note
      @data[:orsr][:note]
    end

    private

    def map_phones(phones)
      phones.map { |e|
        InfoSud::Normalizer.normalize_phone(e[:tel_number])
      }.join(', ')
    end

    def map_office_hours(opening_hours)
      opening_hours[0..14].each_slice(3).map { |hours|
        InfoSud::Normalizer.normalize_hours(hours.map(&:presence).compact.join(', '))
      }
    end
  end
end