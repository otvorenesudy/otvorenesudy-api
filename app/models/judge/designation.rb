class Judge::Designation < ActiveRecord::Base
  belongs_to :source

  belongs_to :judge
  belongs_to :type, class_name: 'Judge::Designation::Type', foreign_key: :judge_designation_type_id
end
