module GenproGovSk
  class ProsecutorsMetadata
    using UnicodeString

    cattr_accessor :metadata

    def self.of(name)
      metadata[Legacy::Normalizer.normalize_person_name(name)]
    end

    def self.metadata
      return @metadata if @metadata

      @metadata = Hash.new

      CSV.foreach(Rails.root.join('data/prosecutors-metadata.csv'), col_sep: ',') do |row|
        name = Legacy::Normalizer.normalize_person_name(row[2], reverse: true)
        data = {
          position: row[3].to_s.strip.capitalize.presence,
          organisation: row[4].to_s.strip.capitalize.presence,
          municipality: row[5].to_s.strip.capitalize.presence
        }

        @metadata[name] = data
      end

      @metadata
    end
  end
end
