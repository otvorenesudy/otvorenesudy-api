# frozen_string_literal: true

# == Schema Information
#
# Table name: proceedings
#
#  id          :integer          not null, primary key
#  file_number :string(255)
#  created_at  :datetime         not null
#  updated_at  :datetime         not null
#
class Proceeding < OpenCourts::ApplicationRecord
  has_many :hearings, dependent: nil
  has_many :decrees, dependent: nil
end
