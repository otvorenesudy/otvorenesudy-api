# == Schema Information
#
# Table name: judge_designation_types
#
#  id         :integer          not null, primary key
#  value      :string(255)      not null
#  created_at :datetime         not null
#  updated_at :datetime         not null
#
class Judge::Designation::Type < OpenCourts::ApplicationRecord
  has_many :designations, class_name: 'Judge::Designation'
end
