# == Schema Information
#
# Table name: decree_natures
#
#  id         :integer          not null, primary key
#  value      :string(255)      not null
#  created_at :datetime         not null
#  updated_at :datetime         not null
#
FactoryBot.define do
  factory :'decree/nature', aliases: [:decree_nature] do
    sequence(:value) { |n| "Decreee Nature ##{n}" }
  end
end
