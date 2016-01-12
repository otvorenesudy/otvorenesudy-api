class Judging < ActiveRecord::Base
  include OpenCourts::Model

  belongs_to :judge, optional: true
  belongs_to :hearing
end
