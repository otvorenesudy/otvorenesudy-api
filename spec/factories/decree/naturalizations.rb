FactoryBot.define do
  factory :'decree/naturalization', aliases: [:decree_naturalization] do
    association :decree
    association :nature, factory: :decree_nature
  end
end
