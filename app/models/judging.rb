# == Schema Information
#
# Table name: judgings
#
#  id                     :integer          not null, primary key
#  hearing_id             :integer          not null
#  judge_id               :integer
#  judge_name_similarity  :decimal(3, 2)    not null
#  judge_name_unprocessed :string(255)      not null
#  judge_chair            :boolean          not null
#  created_at             :datetime         not null
#  updated_at             :datetime         not null
#
class Judging < OpenCourts::ApplicationRecord
  belongs_to :judge, optional: true
  belongs_to :hearing
end
