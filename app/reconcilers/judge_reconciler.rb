# TODO Track employment history (possible feature?)
# -> E1: active (2001 - 2005), E2: active (2004 - 2006)
# -> E3: active (2005 - 2010), E2: active (2004 - 2009) => E1 (inactive)
# -> E2: active (2004 - 2014)
# -> E1: active (2015 - 2016)
#
# => judge.employments = [
#       E1 (2001 - 2005),
#       E2 (2004 - 2014),
#       E3 (2005 - 2010),
#       E1 (2015 - 2016)
#   }

class JudgeReconciler
  attr_reader :mapper, :judge

  def initialize(mapper, judge)
    @mapper = mapper
    @judge = judge
  end

  def reconcile!
    reconcile_attributes
    reconcile_past_employments
    reconcile_employment
    reconcile_temporary_employment

    judge.save!
    judge.touch
  end

  def reconcile_attributes
    name = mapper.partitioned_name

    judge.assign_attributes(
      uri: mapper.uri,
      source: mapper.source,
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
    position = Judge::Position.find_or_create_by!(value: mapper.position)
    court = Court.find_by(name: mapper.court)

    EmploymentBuilder.build_or_update(judge.employments, court: court, position: position, active: mapper.active)
  end

  def reconcile_temporary_employment
    return unless mapper.temporary_court

    position = Judge::Position.find_or_create_by!(value: 'sudca')
    court = Court.find_by(name: mapper.temporary_court)

    EmploymentBuilder.build_or_update(judge.employments, court: court, position: position, active: mapper.active)
  end
end
