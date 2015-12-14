module JusticeGovSk::Judges
  class ResourceCrawler < ActiveJob::Base
    include JusticeGovSk::ResourceCrawler

    queue_as :judge

    def parser
      JusticeGovSk::Judges::ResourceParser
    end

    def repository
      JusticeGovSk::Judge
    end
  end
end
