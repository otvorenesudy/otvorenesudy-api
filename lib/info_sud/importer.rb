module InfoSud
  class Importer
    def self.import(data, parser: InfoSud::Parser, repository:)
      records = parser.parse(data)

      records.each do |attributes|
        repository.import_from(attributes)
      end
    end
  end
end
