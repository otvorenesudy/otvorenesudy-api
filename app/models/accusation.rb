# == Schema Information
#
# Table name: accusations
#
#  id                :integer          not null, primary key
#  defendant_id      :integer          not null
#  value             :string(510)      not null
#  value_unprocessed :string(510)      not null
#  created_at        :datetime         not null
#  updated_at        :datetime         not null
#
class Accusation < ActiveRecord::Base
  include OpenCourts::Model

  belongs_to :defendant

  has_many :paragraph_explanations, as: :explainable
  has_many :paragraphs, through: :paragraph_explanations
end
