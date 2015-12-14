module JusticeGovSk::Courts
  class ResourceCrawler < ActiveJob::Base
    include JusticeGovSk::ResourceCrawler

    queue_as :court

    def parser
      JusticeGovSk::Courts::ResourceParser
    end

    def repository
      JusticeGovSk::Court
    end
  end
end
