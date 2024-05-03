# == Schema Information
#
# Table name: proceedings
#
#  id          :integer          not null, primary key
#  file_number :string(255)
#  created_at  :datetime         not null
#  updated_at  :datetime         not null
#
class Proceeding < ActiveRecord::Base
  include OpenCourts::Model

  has_many :hearings
  has_many :decrees
end
