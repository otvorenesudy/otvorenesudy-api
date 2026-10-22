# frozen_string_literal: true

# == Schema Information
#
# Table name: decree_natures
#
#  id         :integer          not null, primary key
#  value      :string(255)      not null
#  created_at :datetime         not null
#  updated_at :datetime         not null
#
class Decree
  class Nature < OpenCourts::ApplicationRecord
    has_many :naturalizations, class_name: 'Decree::Naturalization', foreign_key: :decree_nature_id, dependent: nil,
                               inverse_of: false
    has_many :decrees, through: :naturalizations
  end
end
