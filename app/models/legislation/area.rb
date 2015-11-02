class Legislation::Area < ActiveRecord::Base
  include OpenCourts::Database

  has_many :subareas, class_name: 'Legislation::Subarea'
  has_many :decrees
end
