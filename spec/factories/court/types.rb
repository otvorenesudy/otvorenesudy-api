# == Schema Information
#
# Table name: court_types
#
#  id         :integer          not null, primary key
#  value      :string(255)      not null
#  created_at :datetime         not null
#  updated_at :datetime         not null
#
FactoryBot.define do
  factory :'court/type', aliases: [:court_type] do
    sequence(:value) { |n| "Type ##{n}" }
  end
end
