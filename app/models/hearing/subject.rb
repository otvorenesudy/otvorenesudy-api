class Hearing::Subject < ActiveRecord::Base
  has_many :hearings
end
