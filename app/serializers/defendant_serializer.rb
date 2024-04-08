# == Schema Information
#
# Table name: defendants
#
#  id               :integer          not null, primary key
#  hearing_id       :integer          not null
#  name             :string(255)      not null
#  name_unprocessed :string(255)      not null
#  created_at       :datetime         not null
#  updated_at       :datetime         not null
#
class DefendantSerializer < ActiveModel::Serializer
  attributes :name
end
