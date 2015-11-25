module JusticeGovSk::Decrees
  class ResourceCrawler < ActiveJob::Base
    include JusticeGovSk::ResourceCrawler

    queue_as :decree

    def parser
      JusticeGovSk::Decrees::ResourceParser
    end

    def persistor
      JusticeGovSk::Decrees::Persistor
    end
  end
end
