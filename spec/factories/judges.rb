FactoryGirl.define do
  factory :judge do
    uri
    source

    sequence(:name)             { |n| "JUDr. Peter Retep #{n}" }
    sequence(:name_unprocessed) { |n| "JUDr. Peter Retep #{n}" }

    prefix   'JUDr.'
    first    'Peter'
    middle   ''
    last     'Retep'
    suffix   'PhD.'
    addition ''

    trait :with_employments do
      after :create do |judge|
        (Random.rand(10) + 1).times.map { create :employment, :active, judge: judge }
      end
    end
  end
end
