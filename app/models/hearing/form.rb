class Hearing::Form < ActiveRecord::Base
  include OpenCourts::Model

  has_many :hearings
end
