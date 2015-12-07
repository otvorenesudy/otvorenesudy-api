module JusticeGovSk::Decrees
  class ListCrawler < ActiveJob::Base
    include JusticeGovSk::ListCrawler

    queue_as :decrees

    def resource_crawler
      JusticeGovSk::Decrees::ResourceCrawler
    end
  end
end
