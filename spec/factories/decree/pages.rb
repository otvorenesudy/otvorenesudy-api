FactoryGirl.define do
  factory :'decree/page', aliases: [:decree_page] do
    association :decree

    sequence(:number) { |n| n }

    text { "Page #{number}" }
  end
end
