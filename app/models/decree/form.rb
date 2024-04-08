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
class Decree::Form < ActiveRecord::Base
  include OpenCourts::Model

  has_many :decrees
end
