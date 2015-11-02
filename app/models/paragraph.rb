class Paragraph < ActiveRecord::Base
  include OpenCourts::Model

  has_many :explanations, class_name: 'Paragraph::Explanation'
end
