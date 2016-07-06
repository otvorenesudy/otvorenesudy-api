class Public::ProsecutorRefinement < ActiveRecord::Base
  validates :email, presence: true, format: { with: /\A([^@\s]+)@((?:[-a-z0-9]+\.)+[a-z]{2,})\z/i, on: :create }
  validates :ip_address, presence: true
  validates :name, presence: true
  validates :prosecutor, presence: true
  validates :office, presence: true
end
