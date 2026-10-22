# frozen_string_literal: true

module InfoSud
  # What each InfoSud mapper says of the record it maps: the source it comes from and the stored record it is, as the
  # reconcilers write them, and the Open Courts judges it names.
  module Mapping
    def initialize(record)
      @record = record
      @data = record.data.deep_symbolize_keys
    end

    def source
      'JusticeGovSk'
    end

    def source_class
      @record.class.name
    end

    def source_class_id
      @record.id
    end

    private

    # InfoSud gives judges by name alone; a name no Open Courts judge has is left out.
    def find_judges(names)
      names.filter_map { |name| ::Judge.find_by(name: InfoSud::Normalizer.normalize_person_name(name)) }
    end
  end
end
