# frozen_string_literal: true

module InfoSud
  class HearingMapper
    include InfoSud::Mapping

    def uri
      "https://obcan.justice.sk/infosud/-/infosud/i-detail/pojednavanie/#{@data[:guid]}"
    end

    def case_number
      @data[:spisova_znacka]
    end

    def file_number
      @data[:identifikacne_cislo_spisu]
    end

    def date
      Time.parse(@data[:datum_a_cas_pojednavania]).utc
    end

    def room
      @data[:miestnost].presence
    end

    def selfjudge
      @data[:je_samosudca]
    end

    def note
      @data[:poznamka].presence
    end

    def special_type
      # TODO: legacy attribute in new dataset, consider
    end

    def court
      InfoSud::Normalizer.normalize_court_name(@data[:sud_nazov])
    end

    # InfoSud doesn't say which court and case a hearing came from.
    def original_court; end

    def original_case_number; end

    def type
      return 'Špecializovaného trestného súdu' if court == 'Špecializovaný trestný súd'
      return 'Trestné' if section == 'T'

      'Civilné'
    end

    def section
      @data[:usek].presence
    end

    def subject
      @data[:predmet].presence
    end

    def form
      @data[:forma_ukonu].presence
    end

    def proposers
      @data[:navrhovatel] || []
    end

    def opponents
      @data[:mena_odporcov] || []
    end

    def defendants
      @data[:mena_obzalovanych] || []
    end

    def judges
      court == 'Špecializovaný trestný súd' ? [] : map_judges
    end

    def chair_judges
      court == 'Špecializovaný trestný súd' ? map_judges : []
    end

    private

    def map_judges
      find_judges(@data[:sudca_meno] || [])
    end
  end
end
