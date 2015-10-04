class Decree < ActiveRecord::Base
  belongs_to :source

  belongs_to :proceeding
  belongs_to :court

  has_many :judgements
  has_many :judges, through: :judgements

  belongs_to :form, class_name: 'Decree::Form', foreign_key: :decree_form_id

  has_many :naturalizations, class_name: 'Decree::Naturalization'
  has_many :natures, class_name: 'Decree::Nature', through: :naturalizations

  belongs_to :legislation_area
  belongs_to :legislation_subarea

  has_many :legislation_usages
  has_many :legislations, through: :legislation_usages

  has_many :paragraph_explanations, through: :legislations
  has_many :paragraphs, through: :paragraph_explanations

  has_many :pages, class_name: 'Decree::Page'
end