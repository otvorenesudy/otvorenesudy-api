# == Schema Information
#
# Table name: employments
#
#  id                :integer          not null, primary key
#  court_id          :integer          not null
#  judge_id          :integer          not null
#  judge_position_id :integer
#  active            :boolean
#  note              :text
#  created_at        :datetime         not null
#  updated_at        :datetime         not null
#  status            :string(255)
#
class Employment < OpenCourts::ApplicationRecord
  belongs_to :court
  belongs_to :judge
  belongs_to :position, class_name: 'Judge::Position', foreign_key: :judge_position_id, optional: true
end
