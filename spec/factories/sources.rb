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
