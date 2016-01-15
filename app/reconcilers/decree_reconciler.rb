class DecreeReconciler
  attr_reader :decree, :mapper

  def initialize(decree, mapper:)
    @decree = decree
    @mapper = mapper
  end

  def reconcile!
    decree.with_lock do
      reconcile_attributes
      reconcile_court
      reconcile_legislation_area
      reconcile_legislation_subarea
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
    decree.update_attributes!(
      source: Source.find_by!(module: 'JusticeGovSk'),
      uri: mapper.uri,
      ecli: mapper.ecli,
      case_number: mapper.case_number,
      file_number: mapper.file_number,
      date: mapper.date,
      form: Decree::Form.find_by!(value: mapper.form, code: mapper.form_code)
    )
  end

  def reconcile_court
    decree.court = Court.find_by!(name: mapper.court)
  end

  def reconcile_legislation_area
    return unless mapper.legislation_area

    decree.legislation_area = Legislation::Area.find_or_create_by!(value: mapper.legislation_area)
  end

  def reconcile_legislation_subarea
    return unless mapper.legislation_area
    return unless mapper.legislation_subarea

    area = Legislation::Area.find_by!(value: mapper.legislation_area)
    decree.legislation_subarea = Legislation::Subarea.find_or_create_by!(value: mapper.legislation_subarea, area: area)
  end

  def reconcile_proceeding
    return unless mapper.file_number

    decree.proceeding = Proceeding.find_or_create_by!(file_number: mapper.file_number)
  end

  def reconcile_judges
    judgements = mapper.judges.map do |name|
      judge = JudgeFinder.find_by(name: name)
      judgement = Judgement.find_or_initialize_by(decree: decree, judge_name_unprocessed: name)

      judgement.update_attributes!(
        judge: judge,
        judge_name_similarity: judge ? 1 : 0
      )

      judgement
    end

    decree.purge!(:judgements, except: judgements)
  end

  def reconcile_natures
    naturalizations = mapper.natures.map do |name|
      nature = Decree::Nature.find_or_create_by!(value: name)

      Decree::Naturalization.find_or_create_by!(decree: decree, nature: nature)
    end

    decree.purge!(:naturalizations, except: naturalizations)
  end

  def reconcile_legislations
    usages = mapper.legislations.map do |attributes|
      legislation = Legislation.find_or_initialize_by(attributes.slice(:value))

      legislation.update_attributes!(attributes)

      Legislation::Usage.find_or_create_by!(decree: decree, legislation: legislation)
    end

    decree.purge!(:legislation_usages, except: usages)
  end

  def reconcile_pages
    # TODO remove Decree::Page and use decree.text instead? as optimization without
    # downloading pdf
    page = Decree::Page.find_or_initialize_by(decree: decree, number: 1)

    page.update_attributes!(text: mapper.text)

    decree.purge!(:pages, except: [page])
  end
end
