module ObcanJusticeSk::Hearings
  class ResourceCrawler < ActiveJob::Base
    include ObcanJusticeSk::ResourceCrawler

    queue_as :hearing

    def parser
      ObcanJusticeSk::Hearings::ResourceParser
    end

    def repository
      Legacy::Hearing
    end
  end
end
