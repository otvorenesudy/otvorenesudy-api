# == Schema Information
#
# Table name: hearing_forms
#
#  id         :integer          not null, primary key
#  value      :string(255)      not null
#  created_at :datetime         not null
#  updated_at :datetime         not null
#
class Hearing::Form < ActiveRecord::Base
  include OpenCourts::Model

  has_many :hearings
end
