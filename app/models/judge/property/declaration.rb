# == Schema Information
#
# Table name: judge_property_declarations
#
#  id         :integer          not null, primary key
#  uri        :string(255)
#  source_id  :integer          not null
#  court_id   :integer          not null
#  judge_id   :integer          not null
#  year       :integer          not null
#  created_at :datetime         not null
#  updated_at :datetime         not null
#
class Judge::Property::Declaration < OpenCourts::ApplicationRecord
  belongs_to :source
  belongs_to :court
  belongs_to :judge

  has_many :lists, class_name: 'Judge::Property::List', dependent: :destroy
  has_many :incomes, class_name: 'Judge::Income', dependent: :destroy
  has_many :proclaims, class_name: 'Judge::Proclaim', dependent: :destroy
  has_many :statements, class_name: 'Judge::Statement', through: :proclaims
  has_many :related_people,
           class_name: 'Judge::RelatedPerson',
           foreign_key: :judge_property_declaration_id,
           dependent: :destroy
end
