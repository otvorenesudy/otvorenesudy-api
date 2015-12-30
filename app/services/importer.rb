module Importer
  def self.import_or_update(record, attributes:)
    record.attributes = attributes

    return unless record.changed?

    record.update_attributes!(attributes)
  end
end
