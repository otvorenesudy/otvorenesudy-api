module ObcanJusticeSk
  class CivilHearingMapper
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
      "https://www.justice.gov.sk/sudy-a-rozhodnutia/sudy/pojednavania/#{data[:guid]}"
    end

    def type
      'Civilné'
    end

    def judges
      return [] unless data[:sudca].present?

      data[:sudca]
        .map do |e|
          name = ObcanJusticeSk::Normalizer.normalize_person_name(e[:meno])
          guid = e[:registreGuid].match(/null/) ? nil : e[:registreGuid]

          ObcanJusticeSk::JudgeFinder.find_by(name: name, guid: guid)
        end
        .compact if data[:sudca]
    end

    def court
      ObcanJusticeSk::Normalizer.normalize_court_name(data[:sud][:nazov]) if data[:sud]
    end

    def original_court
      ObcanJusticeSk::Normalizer.normalize_court_name(data[:povodnySud][:nazov]) if data[:povodnySud]
    end

    def case_number
      data[:spisovaZnacka].presence
    end

    def original_case_number
      data[:povodnaSpisovaZnacka].presence
    end

    def file_number
      data[:identifikacneCislo].presence
    end

    def subject
      data[:predmet].presence
    end

    def section
      data[:usek].presence
    end

    def form
      data[:formaUkonu].presence
    end

    def room
      data[:miestnost].presence
    end

    def date
      date = data[:datumPojednavania].presence
      time = data[:casPojednavania].presence

      return nil if !date && !time
      return Time.parse("#{date} 00:00 +0000") unless time

      "#{date} #{time}".in_time_zone('Europe/Bratislava')
    end

    def note
      data[:poznamky].presence
    end

    def proposers
      return [] unless data[:navrhovatelia].present?

      data[:navrhovatelia].map { |e| e[:meno] }
    end

    def opponents
      return [] unless data[:odporcovia].present?

      data[:odporcovia].map { |e| e[:meno] }
    end

    def defendants
      []
    end

    def selfjudge
      nil
    end

    def special_type
      nil
    end

    def chair_judges
      []
    end
  end
end
