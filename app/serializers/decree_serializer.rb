class DecreeSerializer < ActiveModel::Serializer
  attributes :id, :case_number, :file_number, :ecli, :text, :date, :uri, :document_url, :created_at, :updated_at

  has_one :court
  has_one :form
  has_one :legislation_area
  has_one :legislation_subarea

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
    # TODO if merging with main application, change this to routes url
    "http://otvorenesudy.sk/decrees/#{object.id}/document"
  end

  def date
    object.date.try(:to_date)
  end

  def judges
    object.judgements.map { |judgement|
      if judgement.judge_name_similarity.to_f == 1.0
        judgement.judge
      else
        judge = Judge.new(name: judgement.judge_name_unprocessed)

        judge.readonly!

        judge
      end
    }.compact
  end

  def proposers
    return [] unless object.proceeding
    return [] unless object.proceeding.hearings.size > 0

    proposers = object.proceeding.hearings.map(&:proposers).flatten.uniq(&:name)

    return proposers
  end

  def defendants
    return [] unless object.proceeding
    return [] unless object.proceeding.hearings.size > 0

    defendants = object.proceeding.hearings.map(&:defendants).flatten.uniq(&:name)

    return defendants
  end

  def opponents
    return [] unless object.proceeding
    return [] unless object.proceeding.hearings.size > 0

    opponents = object.proceeding.hearings.map(&:opponents).flatten.uniq(&:name)

    return opponents
  end
end
