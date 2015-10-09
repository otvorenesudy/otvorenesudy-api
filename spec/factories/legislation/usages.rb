FactoryGirl.define do
  factory :'legislation/usage', aliases: [:legislation_usage] do
    association :legislation
    association :decree
  end
end
