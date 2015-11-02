class Court::Office < ActiveRecord::Base
  include OpenCourts::Model

  belongs_to :court
  belongs_to :type, class_name: 'Court::Office::Type', foreign_key: :court_office_type_id
end
