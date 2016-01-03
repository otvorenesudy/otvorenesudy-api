class JudgeReconciler
  attr_reader :mapper, :judge

  def initialize(judge, mapper:)
    @judge = judge
    @mapper = mapper
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

    EmploymentBuilder.build_or_update(judge.employments, court: court, position: position, active: true)
  end

  class EmploymentBuilder
    def self.build_or_update(association, court:, position:, active:)
      employment = association.find_or_initialize_by(court: court, position: position)

      employment.active = active

      employment.save! unless employment.new_record?
    end
  end
end
