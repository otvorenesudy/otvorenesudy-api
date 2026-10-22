# frozen_string_literal: true

# == Schema Information
#
# Table name: legislation_areas
#
#  id         :integer          not null, primary key
#  value      :string(255)      not null
#  created_at :datetime         not null
#  updated_at :datetime         not null
#
class Legislation
  class AreaSerializer < ActiveModel::Serializer
    attributes :value
  end
end
