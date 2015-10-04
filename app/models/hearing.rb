class Hearing < ActiveRecord::Base
  belongs_to :source

  belongs_to :proceeding
  belongs_to :court

  has_many :judgings
  has_many :judges, through: :judgings

  belongs_to :type,    class_name: 'Hearing::Type',    foreign_key: :hearing_type_id
  belongs_to :section, class_name: 'Hearing::Section', foreign_key: :hearing_section_id
  belongs_to :subject, class_name: 'Hearing::Subject', foreign_key: :hearing_subject_id
  belongs_to :form,    class_name: 'Hearing::Form',    foreign_key: :hearing_form_id

  has_many :proposers
  has_many :opponents
  has_many :defendants

  has_many :accusations, through: :defendants
end
