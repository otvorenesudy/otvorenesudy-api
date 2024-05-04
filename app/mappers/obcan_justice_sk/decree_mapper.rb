module ObcanJusticeSk
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
      'Trestný rozkaz' => 'T',
      'Opatrenie bez poučenia' => 'X',
      'Rozsudok pre vzdanie' => 'X',
      'Čiastočný rozsudok' => 'X',
      'Medzitýmny rozsudok' => 'X',
      'Opatrenie' => 'X'
    }

    attr :decree, :data

    def initialize(decree)
      @decree = decree
      @data = decree.data.deep_symbolize_keys

      pages
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
      name = data[:sudca][:meno]

      [ObcanJusticeSk::Normalizer.normalize_person_name(name)]
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
          ObcanJusticeSk::Normalizer.partition_legislation(value[:nazov]).merge(
            value: value[:nazov],
            value_unprocessed: value[:nazov]
          )
        end
    end

    def pages
      @pages ||=
        begin
          pages = PdfExtractor.extract_text_from_url(pdf_uri, preserve_pages: true)

          raise "Failed to extract text from PDF for #{source_class}:#{source_id}" if !pages || pages[0].blank?

          pages
        end
    end

    def pdf_uri
      data[:dokument][:url]
    end
  end
end
