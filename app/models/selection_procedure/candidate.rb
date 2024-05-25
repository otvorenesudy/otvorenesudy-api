# == Schema Information
#
# Table name: selection_procedure_candidates
#
#  id                        :integer          not null, primary key
#  uri                       :string(255)
#  selection_procedure_id    :integer          not null
#  judge_id                  :integer
#  name                      :string(255)      not null
#  name_unprocessed          :string(255)      not null
#  accomplished_expectations :text
#  oral_score                :string(255)
#  oral_result               :string(255)
#  written_score             :string(255)
#  written_result            :string(255)
#  score                     :string(255)
#  rank                      :string(255)
#  created_at                :datetime         not null
#  updated_at                :datetime         not null
#  application_url           :string(2048)
#  curriculum_url            :string(2048)
#  declaration_url           :string(2048)
#  motivation_letter_url     :string(2048)
#
class SelectionProcedure::Candidate < OpenCourts::ApplicationRecord
  belongs_to :procedure, class_name: 'SelectionProcedure', foreign_key: :selection_procedure_id
  belongs_to :judge, optional: true
end
