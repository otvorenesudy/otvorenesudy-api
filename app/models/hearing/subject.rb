class Hearing::Subject < ActiveRecord::Base
  include OpenCourts::Database

  has_many :hearings
end
