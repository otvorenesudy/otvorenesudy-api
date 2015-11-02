class Hearing::Type < ActiveRecord::Base
  include OpenCourts::Model

  has_many :hearings
end
