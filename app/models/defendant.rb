class Defendant < ActiveRecord::Base
  belongs_to :hearing

  has_many :accusations
end
