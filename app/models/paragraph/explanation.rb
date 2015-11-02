class Paragraph::Explanation < ActiveRecord::Base
  include OpenCourts::Database

  belongs_to :paragraph
  belongs_to :explainable, polymorphic: true
end
