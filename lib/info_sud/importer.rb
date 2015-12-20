module InfoSud
  class Importer
    def self.import(path, parser:, repository:)
      File.open(path) do |file|
        records = parser.parse(file.read)

        records.each do |attributes|
          repository.import_from(attributes)
        end
      end
    end
  end
end
