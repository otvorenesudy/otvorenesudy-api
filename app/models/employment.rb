class Employment < ActiveRecord::Base
  include OpenCourts::Model

  belongs_to :court
  belongs_to :judge
  belongs_to :position, class_name: 'Judge::Position', foreign_key: :judge_position_id, optional: true
end
