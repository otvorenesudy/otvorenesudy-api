class Judging < ActiveRecord::Base
  include OpenCourts::Model

  belongs_to :judge
  belongs_to :hearing
end
