class Judge::Designation::Type < ActiveRecord::Base
  include OpenCourts::Model

  has_many :designations, class_name: 'Judge::Designation'
end
