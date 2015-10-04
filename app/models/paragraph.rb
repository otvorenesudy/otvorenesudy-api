class Paragraph < ActiveRecord::Base
  has_many :explanations, class_name: 'Paragraph::Explanation'
end
