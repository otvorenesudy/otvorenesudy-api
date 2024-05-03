# == Schema Information
#
# Table name: opponents
#
#  id               :integer          not null, primary key
#  hearing_id       :integer          not null
#  name             :string(255)      not null
#  name_unprocessed :string(255)      not null
#  created_at       :datetime         not null
#  updated_at       :datetime         not null
#
FactoryBot.define do
  factory :opponent do
    association :hearing

    sequence(:name) { |n| "Opponent ##{n}" }
    sequence(:name_unprocessed) { |n| "Opponent ##{n}" }
  end
end
