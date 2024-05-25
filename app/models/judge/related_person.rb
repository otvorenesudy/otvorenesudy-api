# == Schema Information
#
# Table name: judge_related_people
#
#  id                            :integer          not null, primary key
#  judge_property_declaration_id :integer          not null
#  name                          :string(255)      not null
#  name_unprocessed              :string(255)      not null
#  institution                   :string(255)
#  function                      :string(255)
#  created_at                    :datetime         not null
#  updated_at                    :datetime         not null
#
class Judge::RelatedPerson < OpenCourts::ApplicationRecord
  belongs_to :property_declaration,
             class_name: 'Judge::Property::Declaration',
             foreign_key: :judge_property_declaration_id
end
