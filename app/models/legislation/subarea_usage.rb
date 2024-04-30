class Legislation::SubareaUsage < ActiveRecord::Base
  include OpenCourts::Model

  belongs_to :subarea, class_name: 'Legislation::Subarea', required: true, foreign_key: :legislation_subarea_id
  belongs_to :decree, required: true
end
