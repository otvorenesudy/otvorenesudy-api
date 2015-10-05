class Employment < ActiveRecord::Base
  belongs_to :court
  belongs_to :judge
  belongs_to :judge_position, class_name: 'Judge::Position', optional: true
end
