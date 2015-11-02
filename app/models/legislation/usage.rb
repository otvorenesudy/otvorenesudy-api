class Legislation::Usage < ActiveRecord::Base
  include OpenCourts::Model

  belongs_to :legislation
  belongs_to :decree
end
