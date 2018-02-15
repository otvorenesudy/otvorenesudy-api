FactoryBot.define do
  factory :hearing do
    uri

    association :source
    association :proceeding
    association :type, factory: :hearing_type
    association :court

    trait :defendants do
      after :build do |hearing|
        3.times do
          hearing.defendants << build(:defendant, hearing: hearing)
        end
      end
    end
  end
end
