module ObcanJusticeSk::Judges
  class ResourceCrawler < ActiveJob::Base
    include ObcanJusticeSk::ResourceCrawler

    queue_as :judge

    def parser
      ObcanJusticeSk::Judges::ResourceParser
    end

    def repository
      ObcanJusticeSk::Judge
    end
  end
end
