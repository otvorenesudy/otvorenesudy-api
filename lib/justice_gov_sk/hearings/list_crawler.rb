module JusticeGovSk::Hearings
  class ListCrawler < ActiveJob::Base
    include JusticeGovSk::ListCrawler

    queue_as :hearings

    def resource_crawler
      JusticeGovSk::Hearings::ResourceCrawler
    end
  end
end
