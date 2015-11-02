class Hearing::Type < ActiveRecord::Base
  include OpenCourts::Database

  has_many :hearings
end
