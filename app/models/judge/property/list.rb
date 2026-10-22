# frozen_string_literal: true

# == Schema Information
#
# Table name: judge_property_lists
#
#  id                            :integer          not null, primary key
#  judge_property_declaration_id :integer          not null
#  judge_property_category_id    :integer          not null
#  created_at                    :datetime         not null
#  updated_at                    :datetime         not null
#
class Judge
  class Property
    class List < OpenCourts::ApplicationRecord
      belongs_to :declaration, class_name: 'Judge::Property::Declaration', foreign_key: :judge_property_declaration_id,
                               inverse_of: false
      belongs_to :category, class_name: 'Judge::Property::Category', foreign_key: :judge_property_category_id,
                            inverse_of: false

      has_many :items, class_name: 'Judge::Property', dependent: :destroy
    end
  end
end
