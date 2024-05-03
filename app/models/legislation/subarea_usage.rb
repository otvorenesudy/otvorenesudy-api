# == Schema Information
#
# Table name: legislation_subarea_usages
#
#  id                     :integer          not null, primary key
#  decree_id              :integer          not null
#  legislation_subarea_id :integer          not null
#  created_at             :datetime         not null
#  updated_at             :datetime         not null
#
class Legislation::SubareaUsage < ActiveRecord::Base
  include OpenCourts::Model

  belongs_to :subarea, class_name: 'Legislation::Subarea', required: true, foreign_key: :legislation_subarea_id
  belongs_to :decree, required: true
end
