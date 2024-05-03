# == Schema Information
#
# Table name: judge_designations
#
#  id                        :integer          not null, primary key
#  uri                       :string(2048)     not null
#  source_id                 :integer          not null
#  judge_id                  :integer          not null
#  judge_designation_type_id :integer
#  date                      :date             not null
#  created_at                :datetime         not null
#  updated_at                :datetime         not null
#
class Judge::Designation < ActiveRecord::Base
  include OpenCourts::Model

  belongs_to :source
  belongs_to :judge
  belongs_to :type, class_name: 'Judge::Designation::Type', foreign_key: :judge_designation_type_id, optional: true
end
