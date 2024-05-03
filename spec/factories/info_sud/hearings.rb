# == Schema Information
#
# Table name: info_sud_hearings
#
#  id         :integer          not null, primary key
#  guid       :string           not null
#  data       :jsonb            not null
#  created_at :datetime         not null
#  updated_at :datetime         not null
#
FactoryBot.define do
  factory :'info_sud/hearing', aliases: [:info_sud_hearing] do
    sequence(:guid) { |n| n.to_s }

    data {
      {
        guid: guid,
        identifikacne_cislo_spisu: '123456789'
      }
    }
  end
end
