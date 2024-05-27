# == Schema Information
#
# Table name: hearing_types
#
#  id         :integer          not null, primary key
#  value      :string(255)      not null
#  created_at :datetime         not null
#  updated_at :datetime         not null
#
class Hearing::Type < OpenCourts::ApplicationRecord
  has_many :hearings, foreign_key: :hearing_type_id
end
