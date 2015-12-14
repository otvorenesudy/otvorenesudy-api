module ObcanJusticeSk::Decrees
  class ListCrawler < ActiveJob::Base
    include ObcanJusticeSk::ListCrawler

    queue_as :decrees

    def resource_crawler
      ObcanJusticeSk::Decrees::ResourceCrawler
    end
  end
end
