module OpenCourts
  module Database
    extend ActiveSupport::Concern

    included do
      establish_connection :"opencourts_#{Rails.env}"
    end
  end
end
