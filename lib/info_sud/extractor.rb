module InfoSud
  class Extractor
    def self.extract(path)
      Zip::File.open(path) do |archive|
        archive.each do |entry|
          yield(entry.get_input_stream.read)
        end
      end
    end
  end
end
