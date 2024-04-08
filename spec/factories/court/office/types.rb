# == Schema Information
#
# Table name: court_office_types
#
#  id         :integer          not null, primary key
#  value      :string(255)      not null
#  created_at :datetime         not null
#  updated_at :datetime         not null
#
FactoryBot.define do
  factory :'court/office/type', aliases: [:court_office_type] do
    sequence(:value) { |n| "Court Office Type ##{n}" }
  end
end
