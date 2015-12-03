module JusticeGovSk::Decrees
  class ListCrawler < ActiveJob::Base
    include JusticeGovSk::ListCrawler

    queue_as :decrees

    def uri
      JusticeGovSk::Decrees.uri
    end

    def item_crawler
      JusticeGovSk::Decrees::ItemCrawler
    end
  end
end
