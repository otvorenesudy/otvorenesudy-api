module InfoSud
  module Importable
    def import_from(attributes)
      record = find_or_initialize_by(guid: attributes[:guid])
      delegator = UpdateDelegator.new(record)

      ::Importer.import_or_update(delegator, attributes: { guid: attributes[:guid], data: attributes })
    end
  end
end
