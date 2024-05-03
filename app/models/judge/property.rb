# == Schema Information
#
# Table name: judge_properties
#
#  id                                   :integer          not null, primary key
#  judge_property_list_id               :integer          not null
#  judge_property_acquisition_reason_id :integer
#  judge_property_ownership_form_id     :integer
#  judge_property_change_id             :integer
#  description                          :string(255)
#  acquisition_date                     :string(255)
#  cost                                 :bigint
#  share_size                           :string(255)
#  created_at                           :datetime         not null
#  updated_at                           :datetime         not null
#
class Judge::Property < ActiveRecord::Base
  include OpenCourts::Model

  belongs_to :list, class_name: 'Judge::Property::List', foreign_key: :judge_property_list_id
  belongs_to :acquisition_reason, class_name: 'Judge::Property::AcquisitionReason', foreign_key: :judge_property_acquisition_reason_id
  belongs_to :ownership_form, class_name: 'Judge::Property::OwnershipForm', foreign_key: :judge_property_ownership_form_id
  belongs_to :change, class_name: 'Judge::Property::Change', foreign_key: :judge_property_change_id, optional: true
end
