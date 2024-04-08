# == Schema Information
#
# Table name: employments
#
#  id                :integer          not null, primary key
#  court_id          :integer          not null
#  judge_id          :integer          not null
#  judge_position_id :integer
#  active            :boolean
#  note              :text
#  created_at        :datetime         not null
#  updated_at        :datetime         not null
#  status            :string(255)
#
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
