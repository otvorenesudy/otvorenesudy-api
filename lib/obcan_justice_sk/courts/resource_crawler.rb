module ObcanJusticeSk::Courts
  class ResourceCrawler < ActiveJob::Base
    include ObcanJusticeSk::ResourceCrawler

    queue_as :court

    def parser
      ObcanJusticeSk::Courts::ResourceParser
    end

    def repository
      ObcanJusticeSk::Court
    end
  end
end
