class DecreeReconciler
  include Skylight::Helpers

  attr_reader :decree, :mapper

  def initialize(decree, mapper:)
    @decree = decree
    @mapper = mapper
  end

  def reconcile!
    decree.with_lock do
      reconcile_attributes
      reconcile_court
      reconcile_legislation_areas
      reconcile_legislation_subareas
      reconcile_proceeding
      reconcile_judges
      reconcile_natures
      reconcile_legislations
      reconcile_pages

      decree.save!
      decree.touch
    end
  end

  def reconcile_attributes
    decree.update!(
      source: Source.find_by!(module: 'JusticeGovSk'),
      source_class: mapper.source_class,
      source_class_id: mapper.source_class_id,
      uri: mapper.uri,
      ecli: mapper.ecli,
      case_number: mapper.case_number,
      file_number: mapper.file_number,
      date: mapper.date,
      form: Decree::Form.find_by!(value: mapper.form, code: mapper.form_code),
      pdf_uri: mapper.pdf_uri
    )
  end

  def reconcile_court
    return unless mapper.court

    decree.court = Court.find_by!(name: mapper.court)
  end

  def reconcile_legislation_areas
    return unless mapper.legislation_areas

    usages =
      mapper.legislation_areas.map do |value|
        area = Legislation::Area.find_or_create_by!(value: value)

        Legislation::AreaUsage.find_or_create_by!(decree: decree, area: area)
      end

    decree.purge!(:legislation_area_usages, except: usages)
  end

  def reconcile_legislation_subareas
    return if mapper.legislation_areas.blank?
    return if mapper.legislation_subareas.blank?

    usages =
      mapper.legislation_subareas.map do |value|
        area = Legislation::Subarea.find_or_create_by!(value: value)

        Legislation::SubareaUsage.find_or_create_by!(decree: decree, subarea: area)
      end

    decree.purge!(:legislation_subarea_usages, except: usages)
  end

  def reconcile_proceeding
    return unless mapper.file_number

    decree.proceeding = Proceeding.find_or_create_by!(file_number: mapper.file_number)
  end

  def reconcile_judges
    judgements =
      mapper.judges.map do |judge|
        judgement = Judgement.find_or_initialize_by(decree: decree, judge: judge)

        judgement.update!(judge_name_similarity: 1)
        judgement
      end

    decree.purge!(:judgements, except: judgements)
  end

  def reconcile_natures
    naturalizations =
      mapper.natures.map do |name|
        nature = Decree::Nature.find_or_create_by!(value: name)

        Decree::Naturalization.find_or_create_by!(decree: decree, nature: nature)
      end

    decree.purge!(:naturalizations, except: naturalizations)
  end

  def reconcile_legislations
    usages =
      mapper.legislations.map do |attributes|
        legislation = Legislation.find_or_initialize_by(attributes.slice(:value))

        legislation.update!(attributes)

        Legislation::Usage.find_or_create_by!(decree: decree, legislation: legislation)
      end

    decree.purge!(:legislation_usages, except: usages)
  end

  def reconcile_pages
    return if mapper.pages.blank?

    pages =
      mapper.pages.map.with_index do |text, i|
        page = Decree::Page.find_or_initialize_by(decree: decree, number: i + 1)

        page.update!(text: text)

        page
      end

    decree.purge!(:pages, except: pages)
  end

  instrument_method :reconcile!
  instrument_method :reconcile_attributes
  instrument_method :reconcile_court
  instrument_method :reconcile_legislation_areas
  instrument_method :reconcile_legislation_subareas
  instrument_method :reconcile_proceeding
  instrument_method :reconcile_judges
  instrument_method :reconcile_natures
  instrument_method :reconcile_legislations
  instrument_method :reconcile_pages
end
