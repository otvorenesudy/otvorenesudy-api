class SelectionProcedure < ActiveRecord::Base
  include OpenCourts::Model

  belongs_to :source

  belongs_to :court, optional: true

  has_many :candidates, class_name: 'SelectionProcedure::Candidate'
  has_many :commissioners, class_name: 'SelectionProcedure::Commissioner'
end
