# == Schema Information
#
# Table name: legislation_area_usages
#
#  id                  :integer          not null, primary key
#  decree_id           :integer          not null
#  legislation_area_id :integer          not null
#  created_at          :datetime         not null
#  updated_at          :datetime         not null
#
class Legislation::AreaUsage < ActiveRecord::Base
  include OpenCourts::Model

  belongs_to :area, class_name: 'Legislation::Area', required: true, foreign_key: :legislation_area_id
  belongs_to :decree, required: true
end
