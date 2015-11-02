class Employment < ActiveRecord::Base
  include OpenCourts::Database

  belongs_to :court
  belongs_to :judge
  belongs_to :judge_position, class_name: 'Judge::Position', optional: true
end
