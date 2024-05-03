# == Schema Information
#
# Table name: municipalities
#
#  id         :integer          not null, primary key
#  name       :string(255)      not null
#  zipcode    :string(255)      not null
#  created_at :datetime         not null
#  updated_at :datetime         not null
#
FactoryBot.define do
  factory :municipality do
    sequence(:name) { |n| "Municipality #{n}" }

    zipcode { '0000' }
  end
end
