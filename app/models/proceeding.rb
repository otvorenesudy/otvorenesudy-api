class Proceeding < ActiveRecord::Base
  include OpenCourts::Model

  has_many :hearings
  has_many :decrees
end
