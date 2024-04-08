# == Schema Information
#
# Table name: legislation_areas
#
#  id         :integer          not null, primary key
#  value      :string(255)      not null
#  created_at :datetime         not null
#  updated_at :datetime         not null
#
FactoryBot.define do
  factory :'legislation/area', aliases: [:legislation_area] do
    sequence(:value) { |n| "Legislation Area ##{n}" }
  end
end
