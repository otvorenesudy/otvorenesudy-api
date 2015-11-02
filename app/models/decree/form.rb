class Decree::Form < ActiveRecord::Base
  include OpenCourts::Database

  has_many :decrees
end
