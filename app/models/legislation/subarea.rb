# == Schema Information
#
# Table name: legislation_subareas
#
#  id                  :integer          not null, primary key
#  legislation_area_id :integer          not null
#  value               :string(255)      not null
#  created_at          :datetime         not null
#  updated_at          :datetime         not null
#
class Legislation::Subarea < ActiveRecord::Base
  include OpenCourts::Model

  has_many :usages, class_name: 'Legislation::SubareaUsage'
  has_many :decrees, through: :usages
end
