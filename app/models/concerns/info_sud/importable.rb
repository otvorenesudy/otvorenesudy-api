module InfoSud
  module Importable
    def import_from(attributes)
      record = find_or_initialize_by(guid: attributes[:guid])

      ::Importer.import_or_update(record, attributes: attributes)
    end
  end
end
