module InfoSud
  module Importable
    def filtered_attributes_for_import
      [:index_timestamp]
    end

    def import_from(attributes)
      attributes = attributes.except(*filtered_attributes_for_import)

      record = find_or_initialize_by(guid: attributes[:guid])
      attributes = attributes.slice(:guid).merge(data: attributes)

      ImportManager.import_or_update(record, attributes: attributes)
    end
  end
end
