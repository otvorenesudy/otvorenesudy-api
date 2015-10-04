FactoryGirl.define do
  factory :decree do
    uri

    association :source
    association :court

    sequence(:ecli)        { |n| "ECLI #{n}" }
    sequence(:file_number) { |n| "File Number #{n}" }
    sequence(:case_number) { |n| "Case Number #{n}" }

    form { create :decree_form }
    date { Time.now }

    after :create do |decree|
      3.times.map { create :judgement, decree: decree }
    end
  end
end
