# == Schema Information
#
# Table name: decree_natures
#
#  id         :integer          not null, primary key
#  value      :string(255)      not null
#  created_at :datetime         not null
#  updated_at :datetime         not null
#
class Decree::NatureSerializer < ActiveModel::Serializer
  attributes :value
end
