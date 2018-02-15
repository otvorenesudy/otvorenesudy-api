FactoryBot.define do
  factory :'court/type', aliases: [:court_type] do
    sequence(:value) { |n| "Type ##{n}" }
  end
end
