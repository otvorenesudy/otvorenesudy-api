class Hearing::Section < ActiveRecord::Base
  include OpenCourts::Database

  has_many :hearings
end
