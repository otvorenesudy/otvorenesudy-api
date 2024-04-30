# == Schema Information
#
# Table name: decrees
#
#  id              :integer          not null, primary key
#  uri             :string(2048)     not null
#  source_id       :integer          not null
#  proceeding_id   :integer
#  court_id        :integer
#  decree_form_id  :integer
#  case_number     :string(255)
#  file_number     :string(255)
#  date            :date
#  ecli            :string(255)
#  summary         :text
#  created_at      :datetime         not null
#  updated_at      :datetime         not null
#  pdf_uri         :string(2048)
#  pdf_uri_invalid :boolean          default(FALSE), not null
#  source_class    :string(255)
#  source_class_id :integer
#
FactoryBot.define do
  factory :decree do
    uri

    association :source
    association :court
    association :proceeding

    sequence(:ecli)        { |n| "ECLI #{n}" }
    sequence(:file_number) { |n| "File Number #{n}" }
    sequence(:case_number) { |n| "Case Number #{n}" }

    form { create :decree_form }
    date { Time.now }

    trait :with_judges do
      after :create do |decree|
        3.times.map { create :judgement, decree: decree }
      end
    end
  end
end
