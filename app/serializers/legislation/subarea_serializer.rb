# == Schema Information
#
# Table name: legislation_subareas
#
#  id         :integer          not null, primary key
#  value      :string(255)      not null
#  created_at :datetime         not null
#  updated_at :datetime         not null
#
class Legislation::SubareaSerializer < ActiveModel::Serializer
  attributes :value
end
