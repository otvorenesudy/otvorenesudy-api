FactoryGirl.define do
  factory :judgement do
    association :judge

    judge_name_similarity  1.0
    judge_name_unprocessed 'unprocessed'
  end
end
