# == Schema Information
#
# Table name: legislation_usages
#
#  id             :integer          not null, primary key
#  legislation_id :integer          not null
#  decree_id      :integer          not null
#  created_at     :datetime         not null
#  updated_at     :datetime         not null
#
class Legislation::Usage < ActiveRecord::Base
  include OpenCourts::Model

  belongs_to :legislation
  belongs_to :decree
end
