FactoryBot.define do
  factory :employment do
    association :judge
    association :court

    trait :active do
      active { true }
    end

    trait :inactive do
      active { false }
    end

    trait :unknown do
      active { nil }
    end
  end
end
