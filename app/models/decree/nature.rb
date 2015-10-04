class Decree::Nature < ActiveRecord::Base
  has_many :naturalizations, class_name: 'Decree::Naturalization'
  has_many :decrees, through: :naturalizations
end
