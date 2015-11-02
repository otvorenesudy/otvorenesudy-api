class Decree::Page < ActiveRecord::Base
  include OpenCourts::Database

  belongs_to :decree
end
