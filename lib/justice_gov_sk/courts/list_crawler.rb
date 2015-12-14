module JusticeGovSk::Courts
  class ListCrawler < ActiveJob::Base
    include JusticeGovSk::ListCrawler

    queue_as :courts

    def resource_crawler
      JusticeGovSk::Courts::ResourceCrawler
    end
  end
end
