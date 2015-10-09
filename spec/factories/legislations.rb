FactoryGirl.define do
  factory :legislation do
    sequence(:number) { |n| n }
    sequence(:paragraph) { |n| n }
    sequence(:letter) { |n| "#{n}" }
    sequence(:year) { |n| n }
    sequence(:value) { |n| "Value ##{n}" }
    sequence(:value_unprocessed) { |n| "Unprocessed Value ##{n}" }
  end
end
