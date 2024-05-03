# == Schema Information
#
# Table name: proposers
#
#  id               :integer          not null, primary key
#  hearing_id       :integer          not null
#  name             :string(255)      not null
#  name_unprocessed :string(255)      not null
#  created_at       :datetime         not null
#  updated_at       :datetime         not null
#
FactoryBot.define do
  factory :proposer do
    association :hearing

    sequence(:name) { |n| "Proposer ##{n}" }
    sequence(:name_unprocessed) { |n| "Proposer ##{n}" }
  end
end
