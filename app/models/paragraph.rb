# == Schema Information
#
# Table name: paragraphs
#
#  id          :integer          not null, primary key
#  legislation :integer          not null
#  number      :string(255)      not null
#  description :string(255)      not null
#  created_at  :datetime         not null
#  updated_at  :datetime         not null
#
class Paragraph < OpenCourts::ApplicationRecord
  has_many :explanations, class_name: 'Paragraph::Explanation'
end
