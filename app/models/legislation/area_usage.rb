class Legislation::AreaUsage < ActiveRecord::Base
  include OpenCourts::Model

  belongs_to :area, class_name: 'Legislation::Area', required: true, foreign_key: :legislation_area_id
  belongs_to :decree, required: true
end
