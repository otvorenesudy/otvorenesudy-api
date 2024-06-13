module ObcanJusticeSk
  class DecreeMapper
    FORM_CODE_MAP = {
      'Čiastočný rozsudok' => 'X',
      'Dopĺňací rozsudok' => 'D',
      'Dopĺňacie uznesenie' => 'R',
      'Európsky platobný rozkaz' => 'E',
      'Medzitýmny rozsudok' => 'X',
      'Opatrenie bez poučenia' => 'X',
      'Opatrenie' => 'X',
      'Opravné uznesenie' => 'R',
      'Osvedčenie' => 'B',
      'Platobný rozkaz' => 'P',
      'Príkaz' => 'X',
      'Rozhodnutie' => 'A',
      'Rozkaz na plnenie' => 'L',
      'Rozsudok bez odôvodnenia' => 'F',
      'Rozsudok pre uznanie' => 'U',
      'Rozsudok pre vzdanie' => 'X',
      'Rozsudok pre zmeškanie' => 'K',
      'Rozsudok' => 'A',
      'Šekový platobný rozkaz' => 'S',
      'Trestný rozkaz' => 'T',
      'Uznesenie bez odôvodnenia' => 'C',
      'Uznesenie' => 'N',
      'Výzva' => 'X',
      'Zmenkový platobný rozkaz' => 'M'
    }

    attr :decree, :data

    def initialize(decree)
      @decree = decree
      @data = decree.data.deep_symbolize_keys
    end

    def source
      'JusticeGovSk'
    end

    def source_class
      decree.class.name
    end

    def source_class_id
      decree.id
    end

    def uri
      "https://www.justice.gov.sk/sudy-a-rozhodnutia/sudy/rozhodnutia/#{data[:guid]}"
    end

    def ecli
      data[:ecli].presence
    end

    def court
      name = data[:sud][:nazov]

      ObcanJusticeSk::Normalizer.normalize_court_name(name)
    end

    def judges
      return [] unless data[:sudca] && data[:sudca][:meno]

      name = ObcanJusticeSk::Normalizer.normalize_person_name(data[:sudca][:meno])
      guid = data[:sudca][:registreGuid].match(/null/) ? nil : data[:sudca][:registreGuid]

      [ObcanJusticeSk::JudgeFinder.find_by(name: name, guid: guid)].compact
    end

    def date
      Time.parse(data[:datumVydania]) if data[:datumVydania].present?
    end

    def file_number
      data[:identifikacneCislo].presence
    end

    def case_number
      data[:spisovaZnacka].presence
    end

    def form
      data[:formaRozhodnutia].presence
    end

    def form_code
      FORM_CODE_MAP[form] if form
    end

    def natures
      Array.wrap(data[:povaha].presence)
    end

    def legislation_areas
      Array.wrap(data[:oblast].presence)
    end

    def legislation_subareas
      Array.wrap(data[:podOblast].presence)
    end

    def legislations
      Array
        .wrap(data[:odkazovanePredpisy].presence)
        .map do |value|
          ObcanJusticeSk::Normalizer.partition_legislation(value[:nazov]).merge(value_unprocessed: value[:nazov])
        end
    end

    def pages
      @pages ||=
        begin
          pages = PdfExtractor.extract_text_from_url(pdf_uri, preserve_pages: true)

          if !pages || pages[0].blank?
            raise ArgumentError.new("Failed to extract text from PDF for #{source_class}:#{source_class_id}")
          end

          pages
        rescue StandardError => e
          Sentry.capture_exception(e)

          []
        end
    end

    def pdf_uri
      data[:dokument][:url]
    end
  end
end
