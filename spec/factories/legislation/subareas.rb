FactoryGirl.define do
  factory :'legislation/subarea', aliases: [:legislation_subarea] do
    association :area, factory: :legislation_area

    sequence(:value) { |n| "Legislation Subarea ##{n}" }
  end
end
