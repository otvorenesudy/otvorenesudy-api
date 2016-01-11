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

      judge.save!
      judge.touch
    end
  end

  def reconcile_attributes
    # TODO remove source, leave now for compatibility
    name = mapper.name

    judge.update_attributes!(
      uri: mapper.uri,
      source: Source.find_by(module: 'JusticeGovSk'),
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

    court = Court.find_by(name: mapper.court)
    employment = judge.employments.find_or_initialize_by(court: court)

    employment.update_attributes!(
      position: Judge::Position.find_or_create_by!(value: mapper.position),
      active: mapper.active,
      note: mapper.note
    )
  end

  def reconcile_temporary_employment
    return unless mapper.temporary_court

    court = Court.find_by(name: mapper.temporary_court)
    employment = judge.employments.find_or_initialize_by(court: court)

    employment.update_attributes!(
      position: Judge::Position.find_or_create_by!(value: 'sudca'),
      active: true
    )
  end
end
