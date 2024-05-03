# == Schema Information
#
# Table name: court_jurisdictions
#
#  id                       :integer          not null, primary key
#  court_proceeding_type_id :integer          not null
#  municipality_id          :integer          not null
#  created_at               :datetime         not null
#  updated_at               :datetime         not null
#
class Court::Jurisdiction < ActiveRecord::Base
  include OpenCourts::Model

  belongs_to :proceeding_type, class_name: 'Court::ProceedingType', foreign_key: :court_proceeding_type_id
  belongs_to :municipality

  has_many :courts
end
