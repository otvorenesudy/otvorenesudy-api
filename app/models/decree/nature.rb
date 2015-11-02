class Decree::Nature < ActiveRecord::Base
  include OpenCourts::Model

  has_many :naturalizations, class_name: 'Decree::Naturalization'
  has_many :decrees, through: :naturalizations
end
