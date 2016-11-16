module InfoSud
  class JudgeMapper
    ACTIVITY_MAP = {
      nil => :active,
      'label.sudca.aktivny' => :active,
      'label.sudca.neaktivny' => :inactive,
      'label.sudca.vymazany' => :deleted
    }

    def initialize(data)
      @data = data.symbolize_keys
    end

    def uri
      "https://obcan.justice.sk/infosud/-/infosud/reg-detail/sudca/#{@data[:guid]}"
    end

    def name
      InfoSud::Normalizer.partition_person_name(@data[:meno])
    end

    def position
      @data[:funkcia].try(:downcase)
    end

    def active
      status = ACTIVITY_MAP[@data[:aktivita]]

      return true if status == :active

      false
    end

    def court
      InfoSud::Normalizer.normalize_court_name(@data[:sud]) if @data[:sud]
    end

    def temporary_court
      return if @data[:sud] == @data[:asud]

      InfoSud::Normalizer.normalize_court_name(@data[:asud])
    end

    def note
      @data[:poznamka]
    end
  end
end
