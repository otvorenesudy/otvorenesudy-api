# == Schema Information
#
# Table name: judgements
#
#  id                     :integer          not null, primary key
#  decree_id              :integer          not null
#  judge_id               :integer
#  judge_name_similarity  :decimal(3, 2)    not null
#  judge_name_unprocessed :string(255)      not null
#  created_at             :datetime         not null
#  updated_at             :datetime         not null
#
class Judgement < OpenCourts::ApplicationRecord
  belongs_to :judge, optional: true
  belongs_to :decree

  scope :exact, -> { where(judge_name_similarity: 1.0) }
  scope :inexact, -> { where.not(judge_name_similarity: 1.0) }
end
