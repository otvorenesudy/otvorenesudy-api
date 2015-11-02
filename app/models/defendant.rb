class Defendant < ActiveRecord::Base
  include OpenCourts::Database

  belongs_to :hearing

  has_many :accusations
end
