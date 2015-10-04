class Court::ProceedingType < ActiveRecord::Base
  has_many :jurisdictions, class_name: 'Court::Jurisdiction'
  has_many :courts, through: :jurisdictions
end
