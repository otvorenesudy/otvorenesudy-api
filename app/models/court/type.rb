# == Schema Information
#
# Table name: court_types
#
#  id         :integer          not null, primary key
#  value      :string(255)      not null
#  created_at :datetime         not null
#  updated_at :datetime         not null
#
class Court::Type < ActiveRecord::Base
  include OpenCourts::Model

  has_many :courts, foreign_key: :court_type_id
end
