# == Schema Information
#
# Table name: hearing_types
#
#  id         :integer          not null, primary key
#  value      :string(255)      not null
#  created_at :datetime         not null
#  updated_at :datetime         not null
#
FactoryBot.define do
  factory :'hearing/type', aliases: [:hearing_type] do
    sequence(:value) { |n| "Type ##{n}" }
  end
end
