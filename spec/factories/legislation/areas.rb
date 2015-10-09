FactoryGirl.define do
  factory :'legislation/area', aliases: [:legislation_area] do
    sequence(:value) { |n| "Legislation Area ##{n}" }
  end
end
