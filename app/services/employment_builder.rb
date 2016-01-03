class EmploymentBuilder
  def self.build_or_update(association, court:, position:, active:)
    employment = association.find_or_initialize_by(court: court, position: position)

    employment.active = active

    employment.save! unless employment.new_record?
  end
end
