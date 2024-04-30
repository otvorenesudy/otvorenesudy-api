# == Schema Information
#
# Table name: decree_pages
#
#  id         :integer          not null, primary key
#  decree_id  :integer          not null
#  number     :integer          not null
#  text       :text             not null
#  created_at :datetime         not null
#  updated_at :datetime         not null
#
class Decree::Page < ActiveRecord::Base
  include OpenCourts::Model

  belongs_to :decree, foreign_key: :decree_id
end
