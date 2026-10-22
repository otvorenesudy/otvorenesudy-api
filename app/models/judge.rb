# frozen_string_literal: true

# == Schema Information
#
# Table name: judges
#
#  id               :integer          not null, primary key
#  uri              :string(2048)     not null
#  source_id        :integer          not null
#  name             :string(255)      not null
#  name_unprocessed :string(255)      not null
#  prefix           :string(255)
#  first            :string(255)      not null
#  middle           :string(255)
#  last             :string(255)      not null
#  suffix           :string(255)
#  addition         :string(255)
#  created_at       :datetime         not null
#  updated_at       :datetime         not null
#  source_class     :string(255)
#  source_class_id  :integer
#
class Judge < OpenCourts::ApplicationRecord
  belongs_to :source

  has_many :designations, class_name: 'Judge::Designation', dependent: nil

  has_many :employments, autosave: true, dependent: nil
  has_many :courts, through: :employments
  has_many :positions, through: :employments, source: :judge_position

  has_many :judgings, dependent: nil
  has_many :hearings, through: :judgings

  has_many :judgements, dependent: nil
  has_many :decrees, through: :judgements

  has_many :selection_procedure_commissioners, dependent: nil
  has_many :selection_procedure_candidates, dependent: nil
end
