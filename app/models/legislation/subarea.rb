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

  belongs_to :area, class_name: :'Legislation::Area', foreign_key: :legislation_area_id
  has_many :decrees
end
