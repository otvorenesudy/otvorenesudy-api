# == Schema Information
#
# Table name: municipalities
#
#  id         :integer          not null, primary key
#  name       :string(255)      not null
#  zipcode    :string(255)      not null
#  created_at :datetime         not null
#  updated_at :datetime         not null
#
class Municipality < ActiveRecord::Base
  include OpenCourts::Model

  has_many :courts
  has_many :court_jurisdictions
end
