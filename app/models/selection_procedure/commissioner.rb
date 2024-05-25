# == Schema Information
#
# Table name: selection_procedure_commissioners
#
#  id                     :integer          not null, primary key
#  selection_procedure_id :integer          not null
#  judge_id               :integer
#  name                   :string(255)      not null
#  name_unprocessed       :string(255)      not null
#  created_at             :datetime         not null
#  updated_at             :datetime         not null
#
class SelectionProcedure::Commissioner < OpenCourts::ApplicationRecord
  belongs_to :procedure, class_name: 'SelectionProcedure', foreign_key: :selection_procedure_id
  belongs_to :judge, optional: true
end
