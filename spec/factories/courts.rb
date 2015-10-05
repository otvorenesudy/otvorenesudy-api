FactoryGirl.define do
  factory :court do
    uri

    association :source
    association :municipality
    association :type, factory: :court_type

    sequence(:name) { |n| "Court #{n}" }

    street 'Street'

    trait :with_employments do
      after :create do |court|
        (Random.rand(10) + 1).times.map { create :employment, :active, judge: court }
      end
    end
  end
end
