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
class Decree::FormSerializer < ActiveModel::Serializer
  attributes :code, :value
end
