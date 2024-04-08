# == Schema Information
#
# Table name: decree_forms
#
#  id         :integer          not null, primary key
#  value      :string(255)      not null
#  code       :string(255)      not null
#  created_at :datetime         not null
#  updated_at :datetime         not null
#
FactoryBot.define do
  factory :'decree/form', aliases: [:decree_form] do
    sequence(:value) { |n| "Decree Form #{n}" }
    sequence(:code)  { |n| "Decree Form Code #{n}" }
  end
end
