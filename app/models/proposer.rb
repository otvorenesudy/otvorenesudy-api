class Proposer < ActiveRecord::Base
  include OpenCourts::Database

  belongs_to :hearing
end
