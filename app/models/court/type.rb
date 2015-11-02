class Court::Type < ActiveRecord::Base
  include OpenCourts::Database

  has_many :courts
end
