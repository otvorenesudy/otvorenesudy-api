module ObcanJusticeSk
  class CriminalHearingMapper
    attr :hearing, :data

    def initialize(hearing)
      @hearing = hearing
      @data = hearing.data.deep_symbolize_keys
    end

    def source
      'JusticeGovSk'
    end

    def source_class
      hearing.class.name
    end

    def source_class_id
      hearing.id
    end

    def uri
      "https://www.justice.gov.sk/sudy-a-rozhodnutia/pojednavania/trestne-pojednavania/detail/?eid=#{data[:id]}"
    end

    def type
      return 'Špecializovaného trestného súdu' if court == 'Špecializovaný trestný súd'

      'Trestné'
    end

    def judges
      court == 'Špecializovaný trestný súd' ? [] : map_judges
    end

    def chair_judges
      court == 'Špecializovaný trestný súd' ? map_judges : []
    end

    def court
      ObcanJusticeSk::Normalizer.normalize_court_name(data[:sud][:itemName]) if data[:sud]
    end

    def original_court
      nil
    end

    def case_number
      data[:spisovaZnacka].presence
    end

    def original_case_number
      nil
    end

    def file_number
      data[:ics].presence
    end

    def subject
      data[:predmet].presence
    end

    def section
      data[:usek].presence
    end

    def form
      data[:ukonForma][:itemName] if data[:ukonForma]
    end

    def room
      data[:miestnost].presence
    end

    def date
      Time.parse("#{data[:datumPojednavania]}")
    end

    def note
      data[:poznamka].presence
    end

    def proposers
      []
    end

    def opponents
      []
    end

    def defendants
      data[:obzalovani].presence || []
    end

    def selfjudge
      data[:samosudca]
    end

    def special_type
      data[:typ][:itemName] if data[:typ]
    end

    private

    def map_judges
      data[:sudcovia]
        .map do |judge|
          ObcanJusticeSk::JudgeFinder.find_by(name: ObcanJusticeSk::Normalizer.normalize_person_name(judge), guid: nil)
        end
        .compact
    end
  end
end
