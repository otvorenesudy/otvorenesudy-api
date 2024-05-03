module ObcanJusticeSk
  class CourtMapper
    attr_reader :court, :data

    def initialize(court)
      @court = court
      @data = court.data.deep_symbolize_keys
    end

    def source
      'JusticeGovSk'
    end

    def source_class
      court.class.name
    end

    def source_class_id
      court.id
    end

    def uri
      "https://www.justice.gov.sk/sudy-a-rozhodnutia/sudy/#{data[:registreGuid]}"
    end

    def name
      ObcanJusticeSk::Normalizer.normalize_court_name(data[:nazov])
    end

    def street
      ObcanJusticeSk::Normalizer.normalize_street(data[:adresaString].split(',').first)
    end

    def municipality
      data[:adresa][:obec]
    end

    def zipcode
      ObcanJusticeSk::Normalizer.normalize_zipcode(data[:adresa][:psc])
    end

    def type
      data[:typSudu].split(' ').first
    end

    def latitude
      data[:suradnice][:zemepisnaSirka]
    end

    def longitude
      data[:suradnice][:zemepisnaDlzka]
    end

    def phone
      map_phones(data[:telKontakty], type: 'label.codelist.tel_type.1')
    end

    def fax
      map_phones(data[:telKontakty], type: 'label.codelist.tel_type.3')
    end

    def media_person
      ObcanJusticeSk::Normalizer.normalize_person_name(data[:media][:osoba]) if data[:media][:osoba]
    end

    def media_phone
      map_phones(data[:media][:telKontakty])
    end

    def acronym
      data[:skratka_string]
    end

    def information_center_email
      map_email(data[:infoCentrum].fetch(:internetovaAdresa, { email: [] })[:email].first)
    end

    def information_center_phone
      map_phones(data[:infoCentrum][:telKontakty], type: 'label.codelist.tel_type.1') if data[:infoCentrum]
    end

    def information_center_hours
      map_office_hours(data[:infoCentrum][:otvaracieHodiny])
    end

    def information_center_note
      data[:infoCentrum][:poznamka]
    end

    def registry_center_email
      map_email(data[:podatelna].fetch(:internetovaAdresa, { email: [] })[:email].first)
    end

    def registry_center_phone
      map_phones(data[:podatelna][:telKontakty], type: 'label.codelist.tel_type.1')
    end

    def registry_center_hours
      map_office_hours(data[:podatelna][:otvaracieHodiny])
    end

    def registry_center_note
      data[:podatelna][:poznamka]
    end

    def business_registry_center_email
      map_email(data[:orsr].fetch(:internetovaAdresa, { email: [] })[:email].first) if data[:orsr]
    end

    def business_registry_center_phone
      if data[:orsr] && data[:orsr][:telKontakty]
        map_phones(data[:orsr][:telKontakty], type: 'label.codelist.tel_type.1')
      end
    end

    def business_registry_center_hours
      data[:orsr] ? map_office_hours(data[:orsr][:otvaracieHodiny]).compact : []
    end

    def business_registry_center_note
      data[:orsr][:poznamka] if data[:orsr]
    end

    def data_protection_email
      map_email(data[:ochranaOsobnychUdajov][:email]) if data[:ochranaOsobnychUdajov]
    end

    def other_contacts
      return if data[:kontaktneMiesta].blank?

      data[:kontaktneMiesta]
        .map do |contact|
          next if contact[:nazov].blank?

          {
            name: contact[:nazov],
            note: contact[:poznamka],
            phone: contact[:telKontakty] ? map_phones(contact[:telKontakty], type: 'label.codelist.tel_type.1') : nil,
            email: contact[:internetovaAdresa] ? map_email(contact[:internetovaAdresa][:email].first) : nil,
            hours: contact[:otvaracieHodiny] ? map_office_hours(contact[:otvaracieHodiny]) : nil
          }
        end
        .compact
    end

    def chairmen_of_judicial_council_guids
      data[:srPredseda][:sudcovia].map { |e| "sudca_#{e[:id]}" } if data[:srPredseda] && data[:srPredseda][:sudcovia]
    end

    def members_of_judicial_council_guids
      data[:srPredseda][:sudcovia].map { |e| "sudca_#{e[:id]}" } if data[:srPredseda] && data[:srPredseda][:sudcovia]
    end

    private

    def map_phones(phones, type: nil)
      return unless phones

      phones = phones.select { |e| e[:typ] == type } if type

      return unless phones.any?

      phones.map { |e| ObcanJusticeSk::Normalizer.normalize_phone(e[:cislo]) }.join(', ')
    end

    def map_office_hours(opening_hours)
      opening_hours[0..14]
        .each_slice(3)
        .map { |hours| ObcanJusticeSk::Normalizer.normalize_hours(hours.map(&:presence).compact.join(', ')).presence }
    end

    def map_email(email)
      ObcanJusticeSk::Normalizer.normalize_email(email) if email
    end
  end
end
