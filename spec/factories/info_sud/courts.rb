# == Schema Information
#
# Table name: info_sud_courts
#
#  id         :integer          not null, primary key
#  guid       :string           not null
#  data       :jsonb            not null
#  created_at :datetime         not null
#  updated_at :datetime         not null
#
FactoryBot.define do
  factory :'info_sud/court', aliases: [:info_sud_court] do
    sequence(:guid) { |n| n.to_s }

    data {
      {
        guid: guid,
        nazov: 'Example Court'
      }
    }
  end
end
