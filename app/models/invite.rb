class Invite < ActiveRecord::Base
  validates :email, presence: true, uniqueness: { scope: :locale }
  validates :locale, presence: true

  symbolize :locale, in: [:sk, :en], scopes: true
end
