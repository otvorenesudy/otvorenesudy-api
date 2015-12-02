module JusticeGovSk::Hearings
  class ResourceCrawler < ActiveJob::Base
    include JusticeGovSk::ResourceCrawler

    queue_as :hearing

    def parser
      JusticeGovSk::Hearings::ResourceParser
    end

    def repository
      JusticeGovSk::Hearing
    end
  end
end
