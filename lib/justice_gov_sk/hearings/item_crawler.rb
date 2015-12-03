module JusticeGovSk::Hearings
  class ItemCrawler < ActiveJob::Base
    include JusticeGovSk::ItemCrawler

    queue_as :hearing

    def parser
      JusticeGovSk::Hearings::ItemParser
    end

    def repository
      JusticeGovSk::Hearing
    end
  end
end
