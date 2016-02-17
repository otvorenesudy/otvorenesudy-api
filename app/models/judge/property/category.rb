class Judge::Property::Category < ActiveRecord::Base
  include OpenCourts::Model

  has_many :property_lists, class_name: 'Judge::Property::List', foreign_key: :judge_property_list_id

  validates :value, presence: true
end
