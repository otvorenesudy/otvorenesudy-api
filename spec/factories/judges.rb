FactoryBot.define do
  factory :judge do
    uri
    source

    name { "#{prefix} #{first} #{middle} #{last}, #{suffix} #{addition}".strip.squeeze(' ') }
    name_unprocessed { |n| name }

    prefix { 'JUDr.' }
    first { 'Peter' }
    middle { '' }
    suffix { 'PhD.' }
    addition { '' }

    sequence(:last) { |n| "Retep ##{n}" }

    trait :with_employments do
      after :create do |judge|
        (Random.rand(10) + 1).times.map { create :employment, :active, judge: judge }
      end
    end
  end
end
