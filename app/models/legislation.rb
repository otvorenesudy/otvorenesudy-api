# == Schema Information
#
# Table name: legislations
#
#  id                :integer          not null, primary key
#  value             :string(510)      not null
#  value_unprocessed :string(510)      not null
#  type              :string(255)
#  number            :integer
#  year              :integer
#  name              :string(510)
#  section           :string(255)
#  paragraph         :string(255)
#  letter            :string(255)
#  created_at        :datetime         not null
#  updated_at        :datetime         not null
#
class Legislation < ActiveRecord::Base
  include OpenCourts::Model

  has_many :usages, class_name: :Usage
  has_many :decrees, through: :usages

  has_many :paragraph_explanations, as: :explainable
  has_many :paragraphs, through: :paragraph_explanations

  def self.inheritance_column
  end
end
