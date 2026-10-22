# frozen_string_literal: true

# == Schema Information
#
# Table name: judge_positions
#
#  id         :integer          not null, primary key
#  value      :string(255)      not null
#  created_at :datetime         not null
#  updated_at :datetime         not null
#
class Judge
  class Position < OpenCourts::ApplicationRecord
    has_many :employments, dependent: nil
    has_many :judges, through: :employments
  end
end
