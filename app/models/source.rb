# == Schema Information
#
# Table name: sources
#
#  id         :integer          not null, primary key
#  module     :string(255)      not null
#  name       :string(255)      not null
#  uri        :string(2048)     not null
#  created_at :datetime         not null
#  updated_at :datetime         not null
#
class Source < ActiveRecord::Base
  include OpenCourts::Model
end
