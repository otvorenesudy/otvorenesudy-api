# == Schema Information
#
# Table name: sources
#
#  id         :integer          not null, primary key
#  module     :string(255)      not null
#  name       :string(255)      not null
#  uri        :string(2048)     not null
#  created_at :datetime         not null
#  updated_at :datetime         not null
#
FactoryBot.define do
  sequence(:uri) { |n| "factory_girl_uri_#{n}" }

  factory :source do
    uri

    sequence(:name) { |n| "factory_girl_name_#{n}" }
    sequence(:module) { |n| "factory_girl_module_#{n}" }

    trait :justice_gov_sk do
      name { 'Ministerstvo spravodlivosti Slovenskej republiky' }
      uri { 'http://www.justice.gov.sk' }
      self.module { 'JusticeGovSk' }
    end
  end
end
