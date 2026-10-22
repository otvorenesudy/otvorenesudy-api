# frozen_string_literal: true

module OpenCourts
  class ApplicationRecord < ActiveRecord::Base
    self.abstract_class = true

    connects_to database: { writing: :opencourts, reading: :opencourts }
  end
end
