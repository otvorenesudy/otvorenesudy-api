class Judge::Position < ActiveRecord::Base
  has_many :employments
  has_many :judges, through: :employments
end
