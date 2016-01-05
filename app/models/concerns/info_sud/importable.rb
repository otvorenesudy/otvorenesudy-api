module InfoSud
  module Importable
    def import_from(attributes)
      record = find_or_initialize_by(guid: attributes[:guid])
      attributes = attributes.slice(:guid).merge(data: attributes)

      ImportManager.import_or_update(record, attributes: attributes)
    end
  end
end
