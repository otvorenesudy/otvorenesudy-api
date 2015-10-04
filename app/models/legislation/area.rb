class Legislation::Area < ActiveRecord::Base
  has_many :subareas, class_name: 'Legislation::Subarea'
  has_many :decrees
end
