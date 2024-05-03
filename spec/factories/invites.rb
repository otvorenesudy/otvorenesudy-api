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
FactoryBot.define do
  factory :invite do
    sequence(:email) { |n| "example-#{n}@gmail.com"  }
  end
end
