class SelectionProcedure < ActiveRecord::Base
  belongs_to :source

  belongs_to :court

  has_many :candidates, class_name: 'SelectionProcedure::Candidate'
  has_many :commissioners, class_name: 'SelectionProcedure::Commissioner'
end
