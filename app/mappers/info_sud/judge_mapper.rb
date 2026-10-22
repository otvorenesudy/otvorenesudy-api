# frozen_string_literal: true

module InfoSud
  class JudgeMapper
    ACTIVITY_MAP = {
      '01' => :active,
      '02' => :active, # active, but prosecuted?, e.g. Jankovska
      '03' => :terminated,
      '04' => :inactive,
      '05' => :active, # position changed, more in note (poznamka)
      '06' => :active
    }.freeze

    include InfoSud::Mapping

    def uri
      "https://obcan.justice.sk/infosud/-/infosud/reg-detail/sudca/#{@data[:guid]}"
    end

    def name
      InfoSud::Normalizer.partition_person_name(@data[:meno])
    end

    def position
      @data[:funkcia].try(:downcase)
    end

    def active?
      status == :active || status.nil?
    end

    def status
      ACTIVITY_MAP[@data[:stav]]
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

    # InfoSud doesn't say who sits in the courts' judicial councils.
    def judicial_council_chairman_court_names
      []
    end

    def judicial_council_member_court_names
      []
    end
  end
end
