FactoryGirl.define do
  factory :court do
    uri

    association :source
    association :municipality

    sequence(:name) { |n| "Court #{n}" }

    street 'Street'

    type { CourtType.all.sample }

    trait :with_employments do
      after :create do |court|
        (Random.rand(10) + 1).times.map { create :employment, :active, judge: court }
      end
    end
  end
end
