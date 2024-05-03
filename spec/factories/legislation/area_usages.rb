# == Schema Information
#
# Table name: legislation_area_usages
#
#  id                  :integer          not null, primary key
#  decree_id           :integer          not null
#  legislation_area_id :integer          not null
#  created_at          :datetime         not null
#  updated_at          :datetime         not null
#
FactoryBot.define do
  factory :'legislation/area_usage', aliases: [:legislation_area_usage] do
    association :area, factory: :legislation_area
    association :decree
  end
end
