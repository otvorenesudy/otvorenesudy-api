# == Schema Information
#
# Table name: court_expenses
#
#  id         :integer          not null, primary key
#  uri        :string(2048)     not null
#  source_id  :integer          not null
#  court_id   :integer          not null
#  year       :integer          not null
#  value      :integer          not null
#  created_at :datetime         not null
#  updated_at :datetime         not null
#
class Court::Expense < OpenCourts::ApplicationRecord
  belongs_to :source
  belongs_to :court
end
