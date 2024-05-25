# == Schema Information
#
# Table name: judge_incomes
#
#  id                            :integer          not null, primary key
#  judge_property_declaration_id :integer          not null
#  description                   :string(255)      not null
#  value                         :decimal(12, 2)   not null
#  created_at                    :datetime         not null
#  updated_at                    :datetime         not null
#
class Judge::Income < OpenCourts::ApplicationRecord
  belongs_to :property_declaration,
             class_name: 'Judge::Property::Declaration',
             foreign_key: :judge_property_declaration_id

  validates :description, presence: true
  validates :value, presence: true
end
