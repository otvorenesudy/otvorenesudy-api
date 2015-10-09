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
