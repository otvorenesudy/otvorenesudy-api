class Judge::Property::Declaration < ActiveRecord::Base
  include OpenCourts::Model

  belongs_to :source
  belongs_to :court
  belongs_to :judge

  has_many :lists, class_name: 'Judge::Property::List', dependent: :destroy
  has_many :incomes, class_name: 'Judge::Income', dependent: :destroy
  has_many :proclaims, class_name: 'Judge::Proclaim', dependent: :destroy
  has_many :statements, class_name: 'Judge::Statement', through: :proclaims
  has_many :related_people, class_name: 'Judge::RelatedPerson', foreign_key: :judge_property_declaration_id, dependent: :destroy
end
