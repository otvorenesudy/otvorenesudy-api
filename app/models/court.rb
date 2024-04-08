# == Schema Information
#
# Table name: courts
#
#  id                          :integer          not null, primary key
#  uri                         :string(2048)     not null
#  source_id                   :integer          not null
#  court_type_id               :integer          not null
#  court_jurisdiction_id       :integer
#  municipality_id             :integer          not null
#  name                        :string(255)      not null
#  street                      :string(255)      not null
#  phone                       :string(255)
#  fax                         :string(255)
#  media_person                :string(255)
#  media_person_unprocessed    :string(255)
#  media_phone                 :string(255)
#  information_center_id       :integer
#  registry_center_id          :integer
#  business_registry_center_id :integer
#  latitude                    :decimal(12, 8)
#  longitude                   :decimal(12, 8)
#  created_at                  :datetime         not null
#  updated_at                  :datetime         not null
#  acronym                     :string(255)
#
class Court < ActiveRecord::Base
  include OpenCourts::Model
  include Formattable

  belongs_to :source, autosave: true

  belongs_to :type, class_name: 'Court::Type', foreign_key: :court_type_id, autosave: true

  has_many :employments
  has_many :judges, -> { uniq }, through: :employments

  has_many :hearings
  has_many :decrees

  belongs_to :jurisdiction, class_name: 'Court::Jurisdiction', optional: true, autosave: true
  belongs_to :municipality, autosave: true

  has_many :offices, class_name: 'Court::Office'

  belongs_to :information_center, class_name: 'Court::Office', optional: true, autosave: true
  belongs_to :registry_center, class_name: 'Court::Office', optional: true, autosave: true
  belongs_to :business_registry_center, class_name: 'Court::Office', optional: true, autosave: true

  has_many :expenses, class_name: 'Court::Expense'

  has_many :selection_procedures

  formattable :address, default: '%s, %z %m', remove: /\,\s*\z/ do |court|
    {
      '%s' => court.street,
      '%z' => court.municipality.zipcode,
      '%m' => court.municipality.name,
      '%c' => 'Slovenská republika'
    }
  end
end
