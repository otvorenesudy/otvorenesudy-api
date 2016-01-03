module InfoSud
  class JudgeMapper
    def initialize(judge)
      @judge = judge
      @data = @judge.data.symbolize_keys
    end

    def uri
      "https://obcan.justice.sk/infosud/-/infosud/reg-detail/sudca/#{@data[:guid]}"
    end

    def source
      # TODO remove source dependency in legacy database
      Source.find_by(module: 'JusticeGovSk')
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

    def court
      InfoSud::Normalizer.normalize_court_name(@data[:sud])
    end

    def temporary_court
      return if @data[:sud] == @data[:asud]

      InfoSud::Normalizer.normalize_court_name(@data[:asud])
    end
  end
end
