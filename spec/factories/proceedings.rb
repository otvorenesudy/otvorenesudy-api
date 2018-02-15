FactoryBot.define do
  factory :proceeding do
    trait :with_hearings do
      after :build do |proceeding|
        3.times do
          proceeding.hearings << build(:hearing, :with_defendants, proceeding: proceeding)
        end
      end
    end
  end
end
