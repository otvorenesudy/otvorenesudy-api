# == Schema Information
#
# Table name: hearings
#
#  id                 :integer          not null, primary key
#  uri                :string(2048)     not null
#  source_id          :integer          not null
#  proceeding_id      :integer
#  court_id           :integer
#  hearing_type_id    :integer          not null
#  hearing_section_id :integer
#  hearing_subject_id :integer
#  hearing_form_id    :integer
#  case_number        :string(255)
#  file_number        :string(255)
#  date               :datetime
#  room               :string(255)
#  special_type       :string(255)
#  commencement_date  :datetime
#  selfjudge          :boolean
#  note               :text
#  created_at         :datetime         not null
#  updated_at         :datetime         not null
#  anonymized_at      :datetime
#  source_class       :string(255)
#  source_class_id    :integer
#
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
