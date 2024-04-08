# == Schema Information
#
# Table name: judges
#
#  id               :integer          not null, primary key
#  uri              :string(2048)     not null
#  source_id        :integer          not null
#  name             :string(255)      not null
#  name_unprocessed :string(255)      not null
#  prefix           :string(255)
#  first            :string(255)      not null
#  middle           :string(255)
#  last             :string(255)      not null
#  suffix           :string(255)
#  addition         :string(255)
#  created_at       :datetime         not null
#  updated_at       :datetime         not null
#
class JudgeSerializer < ActiveModel::Serializer
  attributes :id, :name
end
