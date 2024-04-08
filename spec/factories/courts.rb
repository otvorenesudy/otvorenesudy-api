# == Schema Information
#
# Table name: courts
#
#  id                          :integer          not null, primary key
#  uri                         :string(2048)     not null
#  source_id                   :integer          not null
#  court_type_id               :integer          not null
#  court_jurisdiction_id       :integer
#  municipality_id             :integer          not null
#  name                        :string(255)      not null
#  street                      :string(255)      not null
#  phone                       :string(255)
#  fax                         :string(255)
#  media_person                :string(255)
#  media_person_unprocessed    :string(255)
#  media_phone                 :string(255)
#  information_center_id       :integer
#  registry_center_id          :integer
#  business_registry_center_id :integer
#  latitude                    :decimal(12, 8)
#  longitude                   :decimal(12, 8)
#  created_at                  :datetime         not null
#  updated_at                  :datetime         not null
#  acronym                     :string(255)
#
FactoryBot.define do
  factory :court do
    uri

    association :source
    association :municipality
    association :type, factory: :court_type

    sequence(:name) { |n| "Court #{n}" }

    street { 'Street' }

    trait :with_employments do
      after :create do |court|
        (Random.rand(10) + 1).times.map { create :employment, :active, judge: court }
      end
    end
  end
end
