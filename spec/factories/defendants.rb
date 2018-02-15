FactoryBot.define do
  factory :defendant do
    association :hearing

    sequence(:name) { |n| "Defendant ##{n}" }
    sequence(:name_unprocessed) { |n| "Defendant ##{n}" }
  end
end
