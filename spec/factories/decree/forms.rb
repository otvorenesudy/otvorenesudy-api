FactoryGirl.define do
  factory :'decree/form', aliases: [:decree_form] do
    sequence(:value) { |n| "Decree form #{n}" }
    sequence(:code)  { |n| "Decree form code #{n}" }
  end
end
