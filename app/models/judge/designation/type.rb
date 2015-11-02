class Judge::Designation::Type < ActiveRecord::Base
  include OpenCourts::Database

  has_many :designations, class_name: 'Judge::Designation'
end
