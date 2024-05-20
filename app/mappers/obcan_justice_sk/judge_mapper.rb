module ObcanJusticeSk
  class JudgeMapper
    attr :judge, :data

    ACTIVITY_MAP = {
      'label.sudca.aktivny' => :active,
      'label.sudca.odvolany' => :terminated,
      'label.sudca.vymazany' => :deleted,
      'label.sudca.prerusenie vykonu - poberatel' => :inactive,
      'label.sudca.prerusenie vykonu - ina funkce' => :inactive,
      'label.sudca.prerusenie vykonu' => :inactive
    }

    def initialize(judge)
      @judge = judge
      @data = judge.data.deep_symbolize_keys
    end

    def source
      'JusticeGovSk'
    end

    def source_class
      judge.class.name
    end

    def source_class_id
      judge.id
    end

    def uri
      "https://www.justice.gov.sk/sudy-a-rozhodnutia/sudy/sudcovia/#{data[:registreGuid]}"
    end

    def name
      ObcanJusticeSk::Normalizer.partition_person_name(data[:meno])
    end

    def position
      data[:funkcia].try(:downcase) || 'sudca'
    end

    def active
      return true if status == :active

      false
    end

    def status
      ACTIVITY_MAP[data[:stav]]
    end

    def court
      ObcanJusticeSk::Normalizer.normalize_court_name(data[:sud][:nazov]) if data[:sud] && data[:sud][:nazov]
    end

    def temporary_court
      return unless data[:docasnePridelenySud][:nazov]
      return if data[:docasnePridelenySud][:nazov] == data[:sud][:nazov]

      ObcanJusticeSk::Normalizer.normalize_court_name(data[:docasnePridelenySud][:nazov])
    end

    def note
      data[:poznamka]
    end

    def judicial_council_chairman_court_names
      judge.courts_as_judicial_council_chairman.map { |e| ObcanJusticeSk::CourtMapper.new(e).name }
    end

    def judicial_council_member_court_names
      judge.courts_as_judicial_council_member.map { |e| ObcanJusticeSk::CourtMapper.new(e).name }
    end
  end
end
