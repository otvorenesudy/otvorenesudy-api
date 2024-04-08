# == Schema Information
#
# Table name: judgings
#
#  id                     :integer          not null, primary key
#  hearing_id             :integer          not null
#  judge_id               :integer
#  judge_name_similarity  :decimal(3, 2)    not null
#  judge_name_unprocessed :string(255)      not null
#  judge_chair            :boolean          not null
#  created_at             :datetime         not null
#  updated_at             :datetime         not null
#
FactoryBot.define do
  factory :judging do
    association :judge
    association :hearing

    judge_name_similarity { 1.0 }
    judge_name_unprocessed { 'unprocessed' }
    judge_chair { false }
  end
end
