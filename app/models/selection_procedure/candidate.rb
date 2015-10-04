class SelectionProcedure::Candidate < ActiveRecord::Base
  belongs_to :procedure, class_name: 'SelectionProcedure', foreign_key: :selection_procedure_id
  belongs_to :judge
end
