# == Schema Information
#
# Table name: api_keys
#
#  id         :integer          not null, primary key
#  value      :string           not null
#  created_at :datetime         not null
#  updated_at :datetime         not null
#
class Api::Key < ActiveRecord::Base
  before_create :generate_key

  def generate_key
    begin
      self.value = Generator.generate
    end while self.class.exists? value: value
  end

  class Generator
    def self.generate
      SecureRandom.hex
    end
  end
end
