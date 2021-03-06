class SelectionProcedure::Candidate < ActiveRecord::Base
  include OpenCourts::Model

  belongs_to :procedure, class_name: 'SelectionProcedure', foreign_key: :selection_procedure_id
  belongs_to :judge, optional: true
end
