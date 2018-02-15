FactoryBot.define do
  factory :proposer do
    association :hearing

    sequence(:name) { |n| "Proposer ##{n}" }
    sequence(:name_unprocessed) { |n| "Proposer ##{n}" }
  end
end
