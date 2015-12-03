module JusticeGovSk::Judges
  class ListCrawler < ActiveJob::Base
    include JusticeGovSk::ListCrawler

    queue_as :judges

    def uri
      JusticeGovSk::Judges.uri
    end

    def item_crawler
      JusticeGovSk::Judges::ItemCrawler
    end
  end
end
