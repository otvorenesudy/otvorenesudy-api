module ObcanJusticeSk::Judges
  class ListCrawler < ActiveJob::Base
    include ObcanJusticeSk::ListCrawler

    queue_as :judges

    def resource_crawler
      ObcanJusticeSk::Judges::ResourceCrawler
    end
  end
end
