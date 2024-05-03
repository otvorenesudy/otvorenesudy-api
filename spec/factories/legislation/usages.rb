# == Schema Information
#
# Table name: legislation_usages
#
#  id             :integer          not null, primary key
#  legislation_id :integer          not null
#  decree_id      :integer          not null
#  created_at     :datetime         not null
#  updated_at     :datetime         not null
#
FactoryBot.define do
  factory :'legislation/usage', aliases: [:legislation_usage] do
    association :legislation
    association :decree
  end
end
