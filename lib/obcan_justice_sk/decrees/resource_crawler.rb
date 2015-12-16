module ObcanJusticeSk::Decrees
  class ResourceCrawler < ActiveJob::Base
    include ObcanJusticeSk::ResourceCrawler

    queue_as :decree

    def parser
      ObcanJusticeSk::Decrees::ResourceParser
    end

    def repository
      Legacy::Decree
    end
  end
end
