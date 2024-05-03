# == Schema Information
#
# Table name: legislations
#
#  id                :integer          not null, primary key
#  value             :string(510)      not null
#  value_unprocessed :string(510)      not null
#  type              :string(255)
#  number            :integer
#  year              :integer
#  name              :string(510)
#  section           :string(255)
#  paragraph         :string(255)
#  letter            :string(255)
#  created_at        :datetime         not null
#  updated_at        :datetime         not null
#
class LegislationSerializer < ActiveModel::Serializer
  attributes :name, :number, :letter, :paragraph, :section, :type, :year, :value, :value_unprocessed, :external_url

  def external_url
    if object.year && object.number
      url =  "http://www.zakonypreludi.sk/zz/#{object.year}-#{object.number}#"
      url << 'p' << object.paragraph if object.paragraph
      url << '-' << object.section   if object.section
      url << '-' << object.letter    if object.letter
    else
      url = 'http://www.zakonypreludi.sk/main/search.aspx?text=' + object.value
    end

    return url
  end
end
