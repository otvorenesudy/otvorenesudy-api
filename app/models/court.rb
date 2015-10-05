class Court < ActiveRecord::Base
  belongs_to :source

  belongs_to :type, class_name: 'Court::Type', foreign_key: :court_type_id

  has_many :employments
  has_many :judges, -> { uniq }, through: :employments

  has_many :hearings
  has_many :decrees

  belongs_to :jurisdiction, class_name: 'Court::Jurisdiction', optional: true
  belongs_to :municipality

  has_many :offices, class_name: 'Court::Office'

  belongs_to :information_center,       class_name: 'Court::Office', optional: true
  belongs_to :registry_center,          class_name: 'Court::Office', optional: true
  belongs_to :business_registry_center, class_name: 'Court::Office', optional: true

  has_many :expenses, class_name: 'Court::Expense'

  has_many :selection_procedures
end
