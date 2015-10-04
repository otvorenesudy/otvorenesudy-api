class Court::Jurisdiction < ActiveRecord::Base
  belongs_to :proceeding_type, class_name: 'Court::ProceedingType', foreign_key: :court_proceeding_type_id
  belongs_to :municipality

  has_many :courts
end
