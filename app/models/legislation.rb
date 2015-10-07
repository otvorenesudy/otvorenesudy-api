class Legislation < ActiveRecord::Base
  has_many :usages, class_name: :Usage
  has_many :decrees, through: :usages

  has_many :paragraph_explanations, as: :explainable
  has_many :paragraphs, through: :paragraph_explanations

  def self.inheritance_column
  end

  def external_url
    if year && number
      url =  "http://www.zakonypreludi.sk/zz/#{year}-#{number}#"
      url << 'p' << paragraph if paragraph
      url << '-' << section   if section
      url << '-' << letter    if letter
    else
      url = 'http://www.zakonypreludi.sk/main/search.aspx?text=' + value
    end

    return url
  end
end
