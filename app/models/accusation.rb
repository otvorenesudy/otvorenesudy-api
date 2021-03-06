class Accusation < ActiveRecord::Base
  include OpenCourts::Model

  belongs_to :defendant

  has_many :paragraph_explanations, as: :explainable
  has_many :paragraphs, through: :paragraph_explanations
end
