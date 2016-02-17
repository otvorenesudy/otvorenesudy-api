class Judge::RelatedPerson < ActiveRecord::Base
  include OpenCourts::Model

  belongs_to :property_declaration, class_name: 'Judge::Property::Declaration', foreign_key: :judge_property_declaration_id
end
