# == Schema Information
#
# Table name: invites
#
#  id         :integer          not null, primary key
#  email      :string           not null
#  locale     :string           not null
#  created_at :datetime         not null
#  updated_at :datetime         not null
#
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
