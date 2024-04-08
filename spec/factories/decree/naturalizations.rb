# == Schema Information
#
# Table name: decree_naturalizations
#
#  id               :integer          not null, primary key
#  decree_id        :integer          not null
#  decree_nature_id :integer          not null
#  created_at       :datetime         not null
#  updated_at       :datetime         not null
#
FactoryBot.define do
  factory :'decree/naturalization', aliases: [:decree_naturalization] do
    association :decree
    association :nature, factory: :decree_nature
  end
end
