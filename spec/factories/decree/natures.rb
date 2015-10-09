FactoryGirl.define do
  factory :'decree/nature', aliases: [:decree_nature] do
    sequence(:value) { |n| "Decreee Nature ##{n}" }
  end
end
