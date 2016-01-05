module InfoSud
  class JudgeMapper
    STATUS_MAP = {
      nil => :active,
      '01' => :active,
      '03' => :deleted,
      '04' => :inactive,
      '06' => :suspended
    }

    def initialize(data)
      @data = data.symbolize_keys
    end

    def uri
      "https://obcan.justice.sk/infosud/-/infosud/reg-detail/sudca/#{@data[:guid]}"
    end

    def name
      partitioned_name[:value]
    end

    def partitioned_name
      InfoSud::Normalizer.partition_person_name(@data[:meno])
    end

    def position
      @data[:funkcia].downcase
    end

    def active
      status = STATUS_MAP[@data[:stav]]

      return true if status == :active

      false
    end

    def court
      InfoSud::Normalizer.normalize_court_name(@data[:sud])
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
