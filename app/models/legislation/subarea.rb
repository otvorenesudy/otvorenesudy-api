# == Schema Information
#
# Table name: legislation_subareas
#
#  id         :integer          not null, primary key
#  value      :string(255)      not null
#  created_at :datetime         not null
#  updated_at :datetime         not null
#
class Legislation::Subarea < ActiveRecord::Base
  include OpenCourts::Model

  has_many :usages, class_name: 'Legislation::SubareaUsage', foreign_key: :legislation_subarea_id
  has_many :decrees, through: :usages
end
