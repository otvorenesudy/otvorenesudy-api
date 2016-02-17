class Judge::Property::List < ActiveRecord::Base
  include OpenCourts::Model

  belongs_to :declaration, class_name: 'Judge::Property::Declaration', foreign_key: :judge_property_declaration_id
  belongs_to :category, class_name: 'Judge::Property::Category', foreign_key: :judge_property_category_id

  has_many :items, class_name: 'Judge::Property', dependent: :destroy
end
