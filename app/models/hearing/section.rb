# == Schema Information
#
# Table name: hearing_sections
#
#  id         :integer          not null, primary key
#  value      :string(255)      not null
#  created_at :datetime         not null
#  updated_at :datetime         not null
#
class Hearing::Section < ActiveRecord::Base
  include OpenCourts::Model

  has_many :hearings, foreign_key: :hearing_section_id
end
