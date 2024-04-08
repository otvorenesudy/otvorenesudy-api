# == Schema Information
#
# Table name: decree_pages
#
#  id         :integer          not null, primary key
#  decree_id  :integer          not null
#  number     :integer          not null
#  text       :text             not null
#  created_at :datetime         not null
#  updated_at :datetime         not null
#
FactoryBot.define do
  factory :'decree/page', aliases: [:decree_page] do
    association :decree

    sequence(:number) { |n| n }

    text { "Page #{number}" }
  end
end
