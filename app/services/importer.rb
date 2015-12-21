module Importer
  def self.import_or_update(record, attributes:, restricted_attributes: [])
    attributes.symbolize_keys!

    keys = attributes.keys - restricted_attributes.map(&:to_sym)

    return if record.attributes.deep_symbolize_keys.slice(*keys) == attributes.slice(*keys)

    record.attributes = attributes
    record.save!
  end
end
