class Court::Type < ActiveRecord::Base
  include OpenCourts::Model

  has_many :courts
end
