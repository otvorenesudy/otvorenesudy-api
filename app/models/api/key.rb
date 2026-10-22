# frozen_string_literal: true

# == Schema Information
#
# Table name: api_keys
#
#  id         :integer          not null, primary key
#  value      :string           not null
#  created_at :datetime         not null
#  updated_at :datetime         not null
#
module Api
  class Key < ApplicationRecord
    before_create :generate_key

    def generate_key
      loop do
        self.value = Generator.generate
        break unless self.class.exists?(value:)
      end
    end

    class Generator
      def self.generate
        SecureRandom.hex
      end
    end
  end
end
