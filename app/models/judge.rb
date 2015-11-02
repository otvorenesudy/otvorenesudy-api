class Judge < ActiveRecord::Base
  include OpenCourts::Model

  belongs_to :source

  has_many :designations, class_name: 'Judge::Designation'

  has_many :employments
  has_many :courts, through: :employments
  has_many :positions, through: :employments, source: :judge_position

  has_many :judgings
  has_many :hearings, through: :judgings

  has_many :judgements
  has_many :decrees, through: :judgements

  has_many :selection_procedure_commissioners
  has_many :selection_procedure_candidates
end
