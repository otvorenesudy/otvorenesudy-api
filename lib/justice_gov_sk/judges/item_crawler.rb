module JusticeGovSk::Judges
  class ItemCrawler < ActiveJob::Base
    include JusticeGovSk::ItemCrawler

    queue_as :judge

    def parser
      JusticeGovSk::Judges::ItemParser
    end

    def repository
      JusticeGovSk::Judge
    end
  end
end
