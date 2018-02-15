FactoryBot.define do
  factory :invite do
    sequence(:email) { |n| "example-#{n}@gmail.com"  }
  end
end
