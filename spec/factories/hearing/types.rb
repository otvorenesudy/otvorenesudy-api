FactoryGirl.define do
  factory :'hearing/type', aliases: [:hearing_type] do
    sequence(:value) { |n| "Type ##{n}" }
  end
end
