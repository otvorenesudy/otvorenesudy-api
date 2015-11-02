class Paragraph::Explanation < ActiveRecord::Base
  include OpenCourts::Model

  belongs_to :paragraph
  belongs_to :explainable, polymorphic: true
end
