# == Schema Information
#
# Table name: judge_property_acquisition_reasons
#
#  id         :integer          not null, primary key
#  value      :string(255)      not null
#  created_at :datetime         not null
#  updated_at :datetime         not null
#
class Judge::Property::AcquisitionReason < OpenCourts::ApplicationRecord
  has_many :properties, class_name: 'Judge::Property', foreign_key: :judge_property_id

  validates :value, presence: true
end
