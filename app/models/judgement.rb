class Judgement < ActiveRecord::Base
  belongs_to :judge
  belongs_to :decree

  scope :exact, -> { where(judge_name_similarity: 1.0) }
  scope :inexact, -> { where.not(judge_name_similarity: 1.0) }
end
