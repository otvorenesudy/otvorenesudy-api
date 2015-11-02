class Decree::Page < ActiveRecord::Base
  include OpenCourts::Model

  belongs_to :decree
end
