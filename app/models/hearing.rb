# == Schema Information
#
# Table name: hearings
#
#  id                 :integer          not null, primary key
#  uri                :string(2048)     not null
#  source_id          :integer          not null
#  proceeding_id      :integer
#  court_id           :integer
#  hearing_type_id    :integer          not null
#  hearing_section_id :integer
#  hearing_subject_id :integer
#  hearing_form_id    :integer
#  case_number        :string(255)
#  file_number        :string(255)
#  date               :datetime
#  room               :string(255)
#  special_type       :string(255)
#  commencement_date  :datetime
#  selfjudge          :boolean
#  note               :text
#  created_at         :datetime         not null
#  updated_at         :datetime         not null
#  anonymized_at      :datetime
#  source_class       :string(255)
#  source_class_id    :integer
#
class Hearing < ActiveRecord::Base
  include OpenCourts::Model
  include Purgeable

  belongs_to :source

  belongs_to :proceeding, optional: true
  belongs_to :court, optional: true

  has_many :judgings
  has_many :judges, through: :judgings

  belongs_to :type, class_name: 'Hearing::Type', foreign_key: :hearing_type_id
  belongs_to :section, class_name: 'Hearing::Section', foreign_key: :hearing_section_id, optional: true
  belongs_to :subject, class_name: 'Hearing::Subject', foreign_key: :hearing_subject_id, optional: true
  belongs_to :form, class_name: 'Hearing::Form', foreign_key: :hearing_form_id, optional: true

  has_many :proposers
  has_many :opponents
  has_many :defendants

  has_many :accusations, through: :defendants
end
