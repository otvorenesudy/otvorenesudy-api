# frozen_string_literal: true

# == Schema Information
#
# Table name: court_types
#
#  id         :integer          not null, primary key
#  value      :string(255)      not null
#  created_at :datetime         not null
#  updated_at :datetime         not null
#
class Court
  class Type < OpenCourts::ApplicationRecord
    has_many :courts, foreign_key: :court_type_id, dependent: nil, inverse_of: false
  end
end
