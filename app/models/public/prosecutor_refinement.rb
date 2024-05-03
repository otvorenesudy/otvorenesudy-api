# == Schema Information
#
# Table name: public_prosecutor_refinements
#
#  id         :integer          not null, primary key
#  name       :string           not null
#  email      :string           not null
#  ip_address :string           not null
#  prosecutor :string           not null
#  office     :string           not null
#  created_at :datetime         not null
#  updated_at :datetime         not null
#
class Public::ProsecutorRefinement < ActiveRecord::Base
  validates :email, presence: true, format: { with: /\A([^@\s]+)@((?:[-a-z0-9]+\.)+[a-z]{2,})\z/i, on: :create }
  validates :ip_address, presence: true
  validates :name, presence: true
  validates :prosecutor, presence: true
  validates :office, presence: true
end
