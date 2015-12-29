module InfoSud
  module Importable
    def import_from(attributes)
      record = find_or_initialize_by(guid: attributes[:guid])
      dispatcher = UpdateDispatcher.new(record)

      ::Importer.import_or_update(dispatcher, attributes: { guid: attributes[:guid], data: attributes })
    end
  end
end
