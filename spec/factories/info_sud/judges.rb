# == Schema Information
#
# Table name: info_sud_judges
#
#  id         :integer          not null, primary key
#  guid       :string           not null
#  data       :jsonb            not null
#  created_at :datetime         not null
#  updated_at :datetime         not null
#
FactoryBot.define do
  factory :'info_sud/judge', aliases: [:info_sud_judge] do
    sequence(:guid) { |n| n.to_s }

    data {
      {
        guid: guid,
        meno: 'Example Judge'
      }
    }
  end
end
