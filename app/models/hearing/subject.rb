# frozen_string_literal: true

# == Schema Information
#
# Table name: hearing_subjects
#
#  id         :integer          not null, primary key
#  value      :string(255)      not null
#  created_at :datetime         not null
#  updated_at :datetime         not null
#
class Hearing
  class Subject < OpenCourts::ApplicationRecord
    has_many :hearings, foreign_key: :hearing_subject_id, dependent: nil, inverse_of: false
  end
end
