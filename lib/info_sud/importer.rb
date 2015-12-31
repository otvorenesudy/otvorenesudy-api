module InfoSud
  class Importer
    def self.import(url, parser: InfoSud::Parser, repository:)
      archive = InfoSud::Downloader.download_file(url)

      InfoSud::Extractor.extract(archive) do |data|
        records = parser.parse(data)

        records.each do |attributes|
          repository.import_from(attributes.merge(url: url))
        end
      end
    end
  end
end
