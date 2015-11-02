class Hearing::Section < ActiveRecord::Base
  include OpenCourts::Model

  has_many :hearings
end
