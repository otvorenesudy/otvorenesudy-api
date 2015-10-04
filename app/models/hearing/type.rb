class Hearing::Type < ActiveRecord::Base
  has_many :hearings
end
