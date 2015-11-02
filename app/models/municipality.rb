class Municipality < ActiveRecord::Base
  include OpenCourts::Model

  has_many :courts
  has_many :court_jurisdictions
end
