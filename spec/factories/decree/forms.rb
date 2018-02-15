FactoryBot.define do
  factory :'decree/form', aliases: [:decree_form] do
    sequence(:value) { |n| "Decree Form #{n}" }
    sequence(:code)  { |n| "Decree Form Code #{n}" }
  end
end
