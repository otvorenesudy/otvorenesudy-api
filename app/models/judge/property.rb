class Judge::Property < ActiveRecord::Base
  include OpenCourts::Model

  belongs_to :list, class_name: 'Judge::Property::List', foreign_key: :judge_property_list_id
  belongs_to :acquisition_reason, class_name: 'Judge::Property::AcquisitionReason', foreign_key: :judge_property_acquisition_reason_id
  belongs_to :ownership_form, class_name: 'Judge::Property::OwnershipForm', foreign_key: :judge_property_ownership_form_id
  belongs_to :change, class_name: 'Judge::Property::Change', foreign_key: :judge_property_change_id, optional: true
end
