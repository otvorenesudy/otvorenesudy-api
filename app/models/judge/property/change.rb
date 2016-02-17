class Judge::Property::Change < ActiveRecord::Base
  include OpenCourts::Model

  has_many :properties, class_name: 'Judge::Property', foreign_key: :judge_property_id

  validates :value, presence: true
end
