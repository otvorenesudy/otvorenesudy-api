# frozen_string_literal: true

# == Schema Information
#
# Table name: court_office_types
#
#  id         :integer          not null, primary key
#  value      :string(255)      not null
#  created_at :datetime         not null
#  updated_at :datetime         not null
#
class Court
  class Office
    class Type < OpenCourts::ApplicationRecord
      has_many :offices, class_name: 'Court::Office', dependent: nil
    end
  end
end
