class Municipality < ActiveRecord::Base
  include OpenCourts::Database

  has_many :courts
  has_many :court_jurisdictions
end
