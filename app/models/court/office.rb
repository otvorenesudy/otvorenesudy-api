# == Schema Information
#
# Table name: court_offices
#
#  id                   :integer          not null, primary key
#  court_id             :integer          not null
#  court_office_type_id :integer          not null
#  email                :string(255)
#  phone                :string(255)
#  hours_monday         :string(255)
#  hours_tuesday        :string(255)
#  hours_wednesday      :string(255)
#  hours_thursday       :string(255)
#  hours_friday         :string(255)
#  note                 :text
#  created_at           :datetime         not null
#  updated_at           :datetime         not null
#
class Court::Office < OpenCourts::ApplicationRecord
  belongs_to :court
  belongs_to :type, class_name: 'Court::Office::Type', foreign_key: :court_office_type_id
end
