class Court::Office::Type < ActiveRecord::Base
  include OpenCourts::Database

  has_many :offices, class_name: 'Court::Office'
end
