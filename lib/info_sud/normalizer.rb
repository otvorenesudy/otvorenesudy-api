module InfoSud
  module Normalizer
    # TODO implement normalizations
    # TODO remove dependency on Legacy::Normalizer

    def self.normalize_court_name(value)
      Legacy::Normalizer.normalize_court_name(value)
    end

    def self.normalize_phone(value)
      Legacy::Normalizer.normalize_phone(value)
    end

    def self.normalize_hours(value)
      Legacy::Normalizer.normalize_hours(value)
    end

    def self.normalize_email(value)
      Legacy::Normalizer.normalize_email(value)
    end

    def self.normalize_street(value)
      Legacy::Normalizer.normalize_street(value)
    end

    def self.normalize_zipcode(value)
      Legacy::Normalizer.normalize_zipcode(value)
    end
  end
end
