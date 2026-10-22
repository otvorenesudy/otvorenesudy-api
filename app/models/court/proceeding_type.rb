# frozen_string_literal: true

# == Schema Information
#
# Table name: court_proceeding_types
#
#  id         :integer          not null, primary key
#  value      :string(255)      not null
#  created_at :datetime         not null
#  updated_at :datetime         not null
#
class Court
  class ProceedingType < OpenCourts::ApplicationRecord
    has_many :jurisdictions, class_name: 'Court::Jurisdiction', foreign_key: :court_proceeding_type_id, dependent: nil,
                             inverse_of: false
    has_many :courts, through: :jurisdictions
  end
end
