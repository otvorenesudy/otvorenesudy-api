# == Schema Information
#
# Table name: decree_naturalizations
#
#  id               :integer          not null, primary key
#  decree_id        :integer          not null
#  decree_nature_id :integer          not null
#  created_at       :datetime         not null
#  updated_at       :datetime         not null
#
class Decree::Naturalization < ActiveRecord::Base
  include OpenCourts::Model

  belongs_to :decree
  belongs_to :nature, class_name: 'Decree::Nature', foreign_key: :decree_nature_id
end
