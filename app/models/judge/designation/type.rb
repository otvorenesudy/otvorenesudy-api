class Judge::Designation::Type < ActiveRecord::Base
  has_many :designations, class_name: 'Judge::Designation'
end
