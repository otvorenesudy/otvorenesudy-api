module ImportManager
  def self.import_or_update(record, attributes:, restricted_attributes_for_update: [])
    keys = attributes.keys - restricted_attributes_for_update

    return unless record.attributes.deep_symbolize_keys.slice(*keys) != attributes.slice(*keys)

    record.update!(attributes)
  end
end
