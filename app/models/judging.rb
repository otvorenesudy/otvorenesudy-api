class Judging < ActiveRecord::Base
  include OpenCourts::Database

  belongs_to :judge
  belongs_to :hearing
end
