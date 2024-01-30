class JusticeGovSkPage < ActiveRecord::Base
  enum model: %i[court judge hearing decree]

  validates :uri, presence: true, uniqueness: true
end