class Decree::Form < ActiveRecord::Base
  include OpenCourts::Model

  has_many :decrees
end
