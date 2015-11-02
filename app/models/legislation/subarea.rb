class Legislation::Subarea < ActiveRecord::Base
  include OpenCourts::Database

  belongs_to :area, class_name: :'Legislation::Area', foreign_key: :legislation_area_id
  has_many :decrees
end
