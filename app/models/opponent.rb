class Opponent < ActiveRecord::Base
  include OpenCourts::Model

  belongs_to :hearing
end
