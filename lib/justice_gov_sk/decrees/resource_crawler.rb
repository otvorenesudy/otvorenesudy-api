module JusticeGovSk::Decrees
  class ResourceCrawler < ActiveJob::Base
    include JusticeGovSk::ResourceCrawler

    queue_as :decree

    def self.parser
      JusticeGovSk::Decrees::ResourceParser
    end

    def self.persistor
      JusticeGovSk::Decrees::Persistor
    end
  end
end
