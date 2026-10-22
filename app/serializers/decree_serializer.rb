# frozen_string_literal: true

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
class DecreeSerializer < ActiveModel::Serializer
  attributes :id, :case_number, :file_number, :ecli, :text, :date, :uri, :document_url, :created_at, :updated_at
  attributes :other_judges

  has_one :court
  has_one :form

  has_many :legislation_areas
  has_many :legislation_subareas
  has_many :natures
  has_many :judges
  has_many :legislations
  has_many :defendants
  has_many :opponents
  has_many :proposers

  def text
    object.pages.map(&:text).join
  end

  def document_url
    # TODO: if merging with main application, change this to routes url
    "http://otvorenesudy.sk/decrees/#{object.id}/document"
  end

  def date
    object.date.try(:to_date)
  end

  def judges
    object.exact_judgements.map(&:judge)
  end

  def other_judges
    object.inexact_judgements.map(&:judge_name_unprocessed).uniq
  end

  def proposers
    return [] unless object.proceeding
    return [] unless object.proceeding.hearings.size.positive?

    object.proceeding.hearings.map(&:proposers).flatten.uniq(&:name)
  end

  def defendants
    return [] unless object.proceeding
    return [] unless object.proceeding.hearings.size.positive?

    object.proceeding.hearings.map(&:defendants).flatten.uniq(&:name)
  end

  def opponents
    return [] unless object.proceeding
    return [] unless object.proceeding.hearings.size.positive?

    object.proceeding.hearings.map(&:opponents).flatten.uniq(&:name)
  end
end
