FactoryBot.define do
  factory :municipality do
    sequence(:name) { |n| "Municipality #{n}" }

    zipcode { '0000' }
  end
end
