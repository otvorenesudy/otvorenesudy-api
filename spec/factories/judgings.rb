FactoryGirl.define do
  factory :judging do
    association :judge
    association :hearing

    judge_name_similarity  1.0
    judge_name_unprocessed 'unprocessed'
    judge_chair false
  end
end
