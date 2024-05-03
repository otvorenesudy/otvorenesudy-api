# == Schema Information
#
# Table name: selection_procedures
#
#  id                            :integer          not null, primary key
#  uri                           :string(2048)     not null
#  source_id                     :integer          not null
#  court_id                      :integer
#  organization_name             :string(255)      not null
#  organization_name_unprocessed :string(255)      not null
#  organization_description      :text
#  date                          :date
#  description                   :text
#  place                         :string(255)
#  position                      :string(255)      not null
#  state                         :string(255)
#  workplace                     :string(255)
#  closed_at                     :datetime         not null
#  created_at                    :datetime         not null
#  updated_at                    :datetime         not null
#  declaration_url               :string(2048)
#  report_url                    :string(2048)
#
class SelectionProcedure < ActiveRecord::Base
  include OpenCourts::Model

  belongs_to :source

  belongs_to :court, optional: true

  has_many :candidates, class_name: 'SelectionProcedure::Candidate'
  has_many :commissioners, class_name: 'SelectionProcedure::Commissioner'
end
