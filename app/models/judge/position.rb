class Judge::Position < ActiveRecord::Base
  include OpenCourts::Database

  has_many :employments
  has_many :judges, through: :employments
end
