class Invite < ActiveRecord::Base
  validates :email, format: /\A([^@\s]+)@((?:[-a-z0-9]+\.)+[a-z]{2,})\z/i, presence: true, uniqueness: { scope: :locale }
  validates :locale, presence: true

  symbolize :locale, in: [:sk, :en], scopes: true
end
