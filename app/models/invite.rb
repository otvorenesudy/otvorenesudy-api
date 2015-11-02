class Invite < ActiveRecord::Base
  validates :email, presence: true
end
