class Legislation::Usage < ActiveRecord::Base
  include OpenCourts::Database

  belongs_to :legislation
  belongs_to :decree
end
