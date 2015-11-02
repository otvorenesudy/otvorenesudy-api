class Paragraph < ActiveRecord::Base
  include OpenCourts::Database

  has_many :explanations, class_name: 'Paragraph::Explanation'
end
