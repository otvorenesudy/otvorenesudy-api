module InfoSud
  module Importable
    def import_from(attributes)
      record = find_or_initialize_by(guid: attributes[:guid])
      delegator = UpdateDelegator.new(record)
      attributes = attributes.slice(:url, :guid).merge(data: attributes.except(:url))

      ::Importer.import_or_update(delegator, attributes: attributes)
    end
  end
end
