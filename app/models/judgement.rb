class Judgement < ActiveRecord::Base
  belongs_to :judge
  belongs_to :decree
end
