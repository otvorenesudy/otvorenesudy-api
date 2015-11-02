class Defendant < ActiveRecord::Base
  include OpenCourts::Model

  belongs_to :hearing

  has_many :accusations
end
