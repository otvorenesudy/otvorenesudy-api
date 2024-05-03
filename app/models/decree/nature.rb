# == Schema Information
#
# Table name: decree_natures
#
#  id         :integer          not null, primary key
#  value      :string(255)      not null
#  created_at :datetime         not null
#  updated_at :datetime         not null
#
class Decree::Nature < ActiveRecord::Base
  include OpenCourts::Model

  has_many :naturalizations, class_name: 'Decree::Naturalization', foreign_key: :decree_nature_id
  has_many :decrees, through: :naturalizations
end
