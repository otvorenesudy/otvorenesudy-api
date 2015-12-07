module JusticeGovSk::Judges
  class ListCrawler < ActiveJob::Base
    include JusticeGovSk::ListCrawler

    queue_as :judges

    def uri
      JusticeGovSk::Judges.uri
    end

    def resource_crawler
      JusticeGovSk::Judges::ResourceCrawler
    end
  end
end
