class JudgeReconciler
  attr_reader :mapper, :judge

  def initialize(judge, mapper:)
    @judge = judge
    @mapper = mapper
  end

  def reconcile!
    judge.with_lock do
      reconcile_attributes
      reconcile_past_employments
      reconcile_employment
      reconcile_temporary_employment
      reconcile_as_judicial_council_chairman
      reconcile_as_judicial_council_member

      judge.save!
      judge.touch
    end
  end

  def reconcile_attributes
    # TODO remove source, leave now for compatibility
    name = mapper.name

    judge.update!(
      uri: mapper.uri,
      source: Source.find_by!(module: mapper.source),
      source_class: mapper.source_class,
      source_class_id: mapper.source_class_id,
      name: name[:value],
      name_unprocessed: name[:unprocessed],
      prefix: name[:prefix],
      first: name[:first],
      middle: name[:middle],
      last: name[:last],
      suffix: name[:suffix],
      addition: name[:addition]
    )
  end

  def reconcile_past_employments
    judge.employments.update_all(active: false)
  end

  def reconcile_employment
    return unless mapper.court

    court = Court.find_by!(name: mapper.court)
    employment = judge.employments.find_or_initialize_by(court: court)

    employment.update!(
      position: Judge::Position.find_or_create_by!(value: mapper.position),
      active: mapper.active,
      status: mapper.status,
      note: mapper.note
    )
  end

  def reconcile_temporary_employment
    return unless mapper.temporary_court

    court = Court.find_by!(name: mapper.temporary_court)
    employment = judge.employments.find_or_initialize_by(court: court)

    employment.update!(position: Judge::Position.find_or_create_by!(value: 'sudca'), active: true)
  end

  def reconcile_as_judicial_council_chairman
    return unless mapper.try(:judicial_council_chairman_court_names)

    mapper.judicial_council_chairman_court_names.each do |court_name|
      court = Court.find_by!(name: court_name)
      employment = judge.employments.find_or_initialize_by(court: court)

      employment.update!(position: Judge::Position.find_or_create_by!(value: 'predseda súdnej rady'), active: true)
    end
  end

  def reconcile_as_judicial_council_member
    return unless mapper.try(:judicial_council_member_court_names)

    mapper.judicial_council_member_court_names.each do |court_name|
      court = Court.find_by!(name: court_name)
      employment = judge.employments.find_or_initialize_by(court: court)

      employment.update!(position: Judge::Position.find_or_create_by!(value: 'člen súdnej rady'), active: true)
    end
  end
end
