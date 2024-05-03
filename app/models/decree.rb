# == Schema Information
#
# Table name: decrees
#
#  id              :integer          not null, primary key
#  uri             :string(2048)     not null
#  source_id       :integer          not null
#  proceeding_id   :integer
#  court_id        :integer
#  decree_form_id  :integer
#  case_number     :string(255)
#  file_number     :string(255)
#  date            :date
#  ecli            :string(255)
#  summary         :text
#  created_at      :datetime         not null
#  updated_at      :datetime         not null
#  pdf_uri         :string(2048)
#  pdf_uri_invalid :boolean          default(FALSE), not null
#  source_class    :string(255)
#  source_class_id :integer
#
class Decree < ActiveRecord::Base
  include OpenCourts::Model
  include Purgeable

  belongs_to :source

  # TODO consider this required in future
  belongs_to :proceeding, optional: true
  belongs_to :court, optional: true

  has_many :judgements
  has_many :exact_judgements, -> { exact }, class_name: :Judgement
  has_many :inexact_judgements, -> { inexact }, class_name: :Judgement
  has_many :judges, through: :judgements

  belongs_to :form, class_name: 'Decree::Form', foreign_key: :decree_form_id

  has_many :naturalizations, class_name: 'Decree::Naturalization'
  has_many :natures, class_name: 'Decree::Nature', through: :naturalizations

  has_many :legislation_area_usages, class_name: 'Legislation::AreaUsage'
  has_many :legislation_areas, class_name: 'Legislation::Area', through: :legislation_area_usages, source: :area

  has_many :legislation_subarea_usages, class_name: 'Legislation::SubareaUsage'
  has_many :legislation_subareas,
           class_name: 'Legislation::Subarea',
           through: :legislation_subarea_usages,
           source: :subarea

  has_many :legislation_usages, class_name: 'Legislation::Usage'
  has_many :legislations, through: :legislation_usages

  has_many :paragraph_explanations, class_name: 'Paragraph::Explanation', through: :legislations
  has_many :paragraphs, through: :paragraph_explanations

  has_many :pages, class_name: 'Decree::Page'
end
