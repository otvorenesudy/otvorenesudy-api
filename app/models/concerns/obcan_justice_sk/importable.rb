module ObcanJusticeSk
  module Importable
    def import_from(attributes)
      record = find_or_initialize_by(uri: attributes[:uri])

      ::Importer.import_or_update(record, attributes: attributes, restricted_attributes: [:html])
    end
  end
end
