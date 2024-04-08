module ObcanJusticeSk
  module Importable
    def import_from!(guid:, uri:, data:)
      checksum = Digest::SHA256.hexdigest(data.to_json)

      return if exists?(guid: guid, checksum: checksum)

      record = find_or_initialize_by(guid: guid)

      record.update!(data: data, uri: uri, checksum: checksum)
    end
  end
end
