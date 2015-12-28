module ObcanJusticeSk
  module Importable
    def import_from(attributes)
      record = find_or_initialize_by(uri: attributes[:uri])
      dispatcher = UpdateDispatcher.new(record, restricted_attributes: [:html])

      ::Importer.import_or_update(dispatcher, attributes: attributes)
    end
  end
end
