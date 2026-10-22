# frozen_string_literal: true

# == Schema Information
#
# Table name: judge_property_categories
#
#  id         :integer          not null, primary key
#  value      :string(255)      not null
#  created_at :datetime         not null
#  updated_at :datetime         not null
#
class Judge
  class Property
    class Category < OpenCourts::ApplicationRecord
      has_many :property_lists, class_name: 'Judge::Property::List', foreign_key: :judge_property_list_id,
                                dependent: nil, inverse_of: false

      validates :value, presence: true
    end
  end
end
