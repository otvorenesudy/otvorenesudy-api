module InfoSud
  class CourtMapper
    def initialize(data)
      @data = data.deep_symbolize_keys
    end

    def uri
      "https://obcan.justice.sk/infosud/-/infosud/reg-detail/sud/#{@data[:guid]}"
    end

    def source
      # TODO remove source dependency in legacy database
      Source.find_by(module: 'JusticeGovSk')
    end

    def name
      InfoSud::Normalizer.normalize_court_name(@data[:nazov])
    end

    def street
      InfoSud::Normalizer.normalize_street("#{@data[:addr][:StreetName]} #{@data[:addr][:BuildingNumber]}")
    end

    def municipality
      # TODO remove hotfix when municipality for court is fixed
      @data[:addr][:Municipality] || (name == 'Okresný súd Humenné' && 'Humenné')
    end

    def zipcode
      InfoSud::Normalizer.normalize_zipcode(@data[:addr][:PostalCode])
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

    def acronym
      @data[:skratka]
    end

    def information_center_email
      map_email(@data[:info_centrum].fetch(:internetAddress, {})[:email])
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
      map_email(@data[:podatelna].fetch(:internetAddress, {})[:email])
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
      map_email(@data[:orsr].fetch(:internetAddress, {})[:email])
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

    def map_email(email)
      InfoSud::Normalizer.normalize_email(email) if email
    end
  end
end
