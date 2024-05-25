# == Schema Information
#
# Table name: legislation_areas
#
#  id         :integer          not null, primary key
#  value      :string(255)      not null
#  created_at :datetime         not null
#  updated_at :datetime         not null
#
class Legislation::Area < OpenCourts::ApplicationRecord
  has_many :usages, class_name: 'Legislation::AreaUsage', foreign_key: :legislation_area_id
  has_many :decrees, through: :usages
end
