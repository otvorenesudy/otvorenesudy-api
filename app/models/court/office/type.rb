class Court::Office::Type < ActiveRecord::Base
  include OpenCourts::Model

  has_many :offices, class_name: 'Court::Office'
end
