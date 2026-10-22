# frozen_string_literal: true

# == Schema Information
#
# Table name: legislation_area_usages
#
#  id                  :integer          not null, primary key
#  decree_id           :integer          not null
#  legislation_area_id :integer          not null
#  created_at          :datetime         not null
#  updated_at          :datetime         not null
#
class Legislation
  class AreaUsage < OpenCourts::ApplicationRecord
    belongs_to :area, class_name: 'Legislation::Area', optional: false, foreign_key: :legislation_area_id,
                      inverse_of: false
    belongs_to :decree, optional: false
  end
end
