class Proceeding < ActiveRecord::Base
  include OpenCourts::Database

  has_many :hearings
  has_many :decrees
end
