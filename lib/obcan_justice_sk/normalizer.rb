module ObcanJusticeSk
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

    def self.normalize_person_name(value)
      Legacy::Normalizer.normalize_person_name(value)
    end

    def self.partition_person_name(value)
      Legacy::Normalizer.partition_person_name(value)
    end

    def self.partition_legislation(value)
      value = value.gsub(%r{\A/SK/ZZ/(\d+)/-(\d+)}, '/SK/ZZ/\1/\2')

      year, number = value.match(%r{\A/SK/ZZ/(\d+)/(\d+)})[1..2].map(&:to_i)
      _, paragraph = *value.match(/paragraf-(\d+)/)
      _, section = *value.match(/odsek-(\w+)/)
      _, letter = *value.match(/pismeno-(\w+)/)

      { year: year, number: number, paragraph: paragraph, section: section, letter: letter, value: value }.compact
    end
  end
end
