module JusticeGovSk::Decrees
  class ItemCrawler < ActiveJob::Base
    include JusticeGovSk::ItemCrawler

    queue_as :decree

    def parser
      JusticeGovSk::Decrees::ItemParser
    end

    def repository
      JusticeGovSk::Decree
    end
  end
end
