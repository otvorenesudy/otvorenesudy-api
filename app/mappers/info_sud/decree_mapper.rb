module InfoSud
  class DecreeMapper
    FORM_CODE_MAP = {
      'Rozsudok' => 'A',
      'Rozhodnutie' => 'A',
      'Uznesenie' => 'N',
      'Opravné uznesenie' => 'R',
      'Dopĺňacie uznesenie' => 'R',
      'Dopĺňací rozsudok' => 'D',
      'Platobný rozkaz' => 'P',
      'Zmenkový platobný rozkaz' => 'M',
      'Európsky platobný rozkaz' => 'E',
      'Šekový platobný rozkaz' => 'S',
      'Rozkaz na plnenie' => 'L',
      'Rozsudok pre zmeškanie' => 'K',
      'Rozsudok pre uznanie' => 'U',
      'Rozsudok bez odôvodnenia' => 'F',
      'Uznesenie bez odôvodnenia' => 'C',
      'Osvedčenie' => 'B',
      'Trestný rozkaz' => 'T'
    }

    def initialize(data)
      @data = data.deep_symbolize_keys
    end

    def uri
      "https://obcan.justice.sk/infosud/-/infosud/i-detail/rozhodnutie/#{@data[:guid]}"
    end

    def ecli
      @data[:ecli].presence
    end

    def court
      InfoSud::Normalizer.normalize_court_name(@data[:sud_nazov])
    end

    def judges
      Array.wrap(@data[:sudca_meno].presence).map do |name|
        InfoSud::Normalizer.normalize_person_name(name)
      end
    end

    def date
      Time.parse(@data[:datum_vydania_rozhodnutia]) if @data[:datum_vydania_rozhodnutia].present?
    end

    def file_number
      @data[:identifikacne_cislo_spisu].presence
    end

    def case_number
      @data[:spisova_znacka].presence
    end

    def form
      @data[:forma_rozhodnutia].presence
    end

    def form_code
      # TODO redundant, remove from schema
      FORM_CODE_MAP[form] if form
    end

    def natures
      Array.wrap(@data[:povaha_rozhodnutia].presence)
    end

    def legislation_area
      Array.wrap(@data[:oblast_pravnej_upravy].presence).first
    end

    def legislation_subarea
      Array.wrap(@data[:podoblast_pravnej_upravy].presence).first
    end

    def legislations
      Array.wrap(@data[:odkazovane_predpisy].presence).map do |string|
        InfoSud::Normalizer.partition_legislation(string).merge(value: string, value_unprocessed: string)
      end
    end

    def text
      @data[:dokument_fulltext].presence
    end

    def pdf_uri
      @data[:dokument_download_link].presence
    end
  end
end
