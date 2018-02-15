FactoryBot.define do
  factory :opponent do
    association :hearing

    sequence(:name) { |n| "Opponent ##{n}" }
    sequence(:name_unprocessed) { |n| "Opponent ##{n}" }
  end
end
