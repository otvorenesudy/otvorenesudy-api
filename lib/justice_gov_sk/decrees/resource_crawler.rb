module JusticeGovSk::Decrees
  class ResourceCrawler < ActiveJob::Base
    include JusticeGovSk::ResourceCrawler

    queue_as :decree

    def parser
      JusticeGovSk::Decrees::ResourceParser
    end

    def repository
      JusticeGovSk::Decree
    end
  end
end
