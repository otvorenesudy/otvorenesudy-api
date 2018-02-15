class Invite < ActiveRecord::Base
  extend Enumerize

  validates :email,
    format: /\A([^@\s]+)@((?:[-a-z0-9]+\.)+[a-z]{2,})\z/i,
    presence: true,
    uniqueness: {
      scope: :locale
    }

  validates :locale, presence: true, inclusion: { in: %w[sk en] }
end
