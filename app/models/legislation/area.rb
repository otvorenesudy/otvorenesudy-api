# == Schema Information
#
# Table name: legislation_areas
#
#  id         :integer          not null, primary key
#  value      :string(255)      not null
#  created_at :datetime         not null
#  updated_at :datetime         not null
#
class Legislation::Area < ActiveRecord::Base
  include OpenCourts::Model

  has_many :subareas, class_name: 'Legislation::Subarea'
  has_many :decrees
end
