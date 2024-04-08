# == Schema Information
#
# Table name: hearing_subjects
#
#  id         :integer          not null, primary key
#  value      :string(255)      not null
#  created_at :datetime         not null
#  updated_at :datetime         not null
#
class Hearing::Subject < ActiveRecord::Base
  include OpenCourts::Model

  has_many :hearings
end
