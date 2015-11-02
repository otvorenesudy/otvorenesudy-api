class Hearing::Form < ActiveRecord::Base
  include OpenCourts::Database

  has_many :hearings
end
