class Hearing::Subject < ActiveRecord::Base
  include OpenCourts::Model

  has_many :hearings
end
