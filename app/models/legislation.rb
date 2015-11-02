class Legislation < ActiveRecord::Base
  include OpenCourts::Database

  has_many :usages, class_name: :Usage
  has_many :decrees, through: :usages

  has_many :paragraph_explanations, as: :explainable
  has_many :paragraphs, through: :paragraph_explanations

  def self.inheritance_column
  end
end
