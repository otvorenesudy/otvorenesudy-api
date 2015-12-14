module ObcanJusticeSk::Courts
  class ListCrawler < ActiveJob::Base
    include ObcanJusticeSk::ListCrawler

    queue_as :courts

    def resource_crawler
      ObcanJusticeSk::Courts::ResourceCrawler
    end
  end
end
