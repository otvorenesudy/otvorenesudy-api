# == Schema Information
#
# Table name: legislation_subareas
#
#  id                  :integer          not null, primary key
#  legislation_area_id :integer          not null
#  value               :string(255)      not null
#  created_at          :datetime         not null
#  updated_at          :datetime         not null
#
FactoryBot.define do
  factory :'legislation/subarea', aliases: [:legislation_subarea] do
    association :area, factory: :legislation_area

    sequence(:value) { |n| "Legislation Subarea ##{n}" }
  end
end
