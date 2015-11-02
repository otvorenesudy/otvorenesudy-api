class Judge::Position < ActiveRecord::Base
  include OpenCourts::Model

  has_many :employments
  has_many :judges, through: :employments
end
