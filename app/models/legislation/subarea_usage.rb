# frozen_string_literal: true

# == Schema Information
#
# Table name: legislation_subarea_usages
#
#  id                     :integer          not null, primary key
#  decree_id              :integer          not null
#  legislation_subarea_id :integer          not null
#  created_at             :datetime         not null
#  updated_at             :datetime         not null
#
class Legislation
  class SubareaUsage < OpenCourts::ApplicationRecord
    belongs_to :subarea, class_name: 'Legislation::Subarea', optional: false, foreign_key: :legislation_subarea_id,
                         inverse_of: false
    belongs_to :decree, optional: false
  end
end
