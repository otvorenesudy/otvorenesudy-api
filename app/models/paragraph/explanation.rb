# == Schema Information
#
# Table name: paragraph_explanations
#
#  id               :integer          not null, primary key
#  paragraph_id     :integer          not null
#  explainable_id   :integer          not null
#  explainable_type :string(255)      not null
#  created_at       :datetime         not null
#  updated_at       :datetime         not null
#
class Paragraph::Explanation < ActiveRecord::Base
  include OpenCourts::Model

  belongs_to :paragraph
  belongs_to :explainable, polymorphic: true
end
