# frozen_string_literal: true

# == Schema Information
#
# Table name: decree_forms
#
#  id         :integer          not null, primary key
#  value      :string(255)      not null
#  code       :string(255)      not null
#  created_at :datetime         not null
#  updated_at :datetime         not null
#
class Decree
  class Form < OpenCourts::ApplicationRecord
    has_many :decrees, foreign_key: :decree_form_id, dependent: nil, inverse_of: false
  end
end
