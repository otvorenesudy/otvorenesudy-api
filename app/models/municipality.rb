class Municipality < ActiveRecord::Base
  has_many :courts
  has_many :court_jurisdictions
end
