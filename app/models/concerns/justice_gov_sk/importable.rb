module JusticeGovSk
  module Importable
    def importable_restricted_attributes_for_update
      [:html]
    end

    def import_from(attributes)
      record = find_or_initialize_by(uri: attributes[:uri])

      record.assign_attributes(attributes.except(*importable_restricted_attributes_for_update))

      return unless record.changed?

      record.assign_attributes(attributes.slice(*importable_restricted_attributes_for_update))
      record.save!
    end
  end
end
