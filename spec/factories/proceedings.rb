# == Schema Information
#
# Table name: proceedings
#
#  id          :integer          not null, primary key
#  file_number :string(255)
#  created_at  :datetime         not null
#  updated_at  :datetime         not null
#
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
