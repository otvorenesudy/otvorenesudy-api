module ObcanJusticeSk::Decrees
  class ResourceCrawler < ActiveJob::Base
    include ObcanJusticeSk::ResourceCrawler

    queue_as :decree

    def parser
      ObcanJusticeSk::Decrees::ResourceParser
    end

    def repository
      ObcanJusticeSk::Decree
    end
  end
end
