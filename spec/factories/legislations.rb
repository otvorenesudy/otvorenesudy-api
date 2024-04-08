# == Schema Information
#
# Table name: legislations
#
#  id                :integer          not null, primary key
#  value             :string(510)      not null
#  value_unprocessed :string(510)      not null
#  type              :string(255)
#  number            :integer
#  year              :integer
#  name              :string(510)
#  section           :string(255)
#  paragraph         :string(255)
#  letter            :string(255)
#  created_at        :datetime         not null
#  updated_at        :datetime         not null
#
FactoryBot.define do
  factory :legislation do
    sequence(:number) { |n| n }
    sequence(:paragraph) { |n| n }
    sequence(:letter) { |n| "#{n}" }
    sequence(:year) { |n| n }
    sequence(:value) { |n| "Value ##{n}" }
    sequence(:value_unprocessed) { |n| "Unprocessed Value ##{n}" }
  end
end
