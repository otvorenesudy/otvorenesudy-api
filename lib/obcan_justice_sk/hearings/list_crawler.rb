module ObcanJusticeSk::Hearings
  class ListCrawler < ActiveJob::Base
    include ObcanJusticeSk::ListCrawler

    queue_as :hearings

    def resource_crawler
      ObcanJusticeSk::Hearings::ResourceCrawler
    end
  end
end
