# frozen_string_literal: true

module InfoSud
  class Importer
    def self.import(data, repository:, parser: InfoSud::Parser)
      records = parser.parse(data)

      records.each do |attributes|
        repository.import_from(attributes)
      end
    end
  end
end
