module JusticeGovSk::Judges
  class ListCrawler < ActiveJob::Base
    include JusticeGovSk::ListCrawler

    queue_as :judges

    def resource_crawler
      JusticeGovSk::Judges::ResourceCrawler
    end
  end
end
