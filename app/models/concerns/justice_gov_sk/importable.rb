# TODO report weird bug with utf8 based string array attributes when using changed? method

module JusticeGovSk
  module Importable
    def importable_restricted_attributes_for_update
      [:html]
    end

    def import_from(attributes)
      attributes.symbolize_keys!

      record = find_or_initialize_by(uri: attributes[:uri])
      keys = attributes.keys - importable_restricted_attributes_for_update.map(&:to_sym)

      return if record.attributes.symbolize_keys.slice(*keys) == attributes.symbolize_keys.slice(*keys)

      record.attributes = attributes
      record.save!
    end
  end
end
