# == Schema Information
#
# Table name: info_sud_decrees
#
#  id         :integer          not null, primary key
#  guid       :string           not null
#  data       :jsonb            not null
#  created_at :datetime         not null
#  updated_at :datetime         not null
#
FactoryBot.define do
  factory :'info_sud/decree', aliases: [:info_sud_decree] do
    sequence(:guid) { |n| n.to_s }

    data {
      {
        guid: guid,
        identifikacne_cislo_spisu: '123456789'
      }
    }
  end
end
