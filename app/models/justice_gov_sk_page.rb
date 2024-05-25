# == Schema Information
#
# Table name: justice_gov_sk_pages
#
#  id         :bigint           not null, primary key
#  model      :string           default(NULL), not null
#  integer    :string           default("0"), not null
#  uri        :string           not null
#  data       :jsonb            not null
#  created_at :datetime         not null
#  updated_at :datetime         not null
#
class JusticeGovSkPage < ApplicationRecord
  enum model: %i[court judge hearing decree]

  validates :uri, presence: true, uniqueness: true
end
