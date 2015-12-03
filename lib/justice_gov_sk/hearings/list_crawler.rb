module JusticeGovSk::Hearings
  class ListCrawler < ActiveJob::Base
    include JusticeGovSk::ListCrawler

    queue_as :hearings

    def uri
      JusticeGovSk::Hearings.uri
    end

    def item_crawler
      JusticeGovSk::Hearings::ItemCrawler
    end
  end
end
