# == Schema Information
#
# Table name: opponents
#
#  id               :integer          not null, primary key
#  hearing_id       :integer          not null
#  name             :string(255)      not null
#  name_unprocessed :string(255)      not null
#  created_at       :datetime         not null
#  updated_at       :datetime         not null
#
class Opponent < OpenCourts::ApplicationRecord
  belongs_to :hearing
end
