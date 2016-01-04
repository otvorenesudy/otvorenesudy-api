module InfoSud
  class HearingMapper
    def initialize(data)
      @data = data.deep_symbolize_keys
    end

    def uri
      "https://obcan.justice.sk/infosud/-/infosud/i-detail/pojednavanie/#{@data[:guid]}"
    end

    def case_number
      @data[:spisova_znacka]
    end

    def file_number
      @data[:identifikacne_cislo_spisu]
    end
  end
end
