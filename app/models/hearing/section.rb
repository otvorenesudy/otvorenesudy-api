class Hearing::Section < ActiveRecord::Base
  has_many :hearings
end
