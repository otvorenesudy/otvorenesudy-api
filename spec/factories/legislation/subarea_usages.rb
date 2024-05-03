# == Schema Information
#
# Table name: legislation_subarea_usages
#
#  id                     :integer          not null, primary key
#  decree_id              :integer          not null
#  legislation_subarea_id :integer          not null
#  created_at             :datetime         not null
#  updated_at             :datetime         not null
#
FactoryBot.define do
  factory :'legislation/subarea_usage', aliases: [:legislation_subarea_usage] do
    association :subarea, factory: :legislation_subarea
    association :decree
  end
end
