module ObcanJusticeSk
  module Importable
    def import_from(attributes)
      record = find_or_initialize_by(uri: attributes[:uri])
      delegator = UpdateDelegator.new(record, restricted_attributes: [:html])

      ::Importer.import_or_update(delegator, attributes: attributes)
    end
  end
end
