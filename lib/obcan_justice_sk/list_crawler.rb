module ObcanJusticeSk
  module ListCrawler
    def parser
      ListParser
    end

    def perform(url)
      html = ObcanJusticeSk::Downloader.download(url)
      links = parser.parse(html)

      links.each do |link|
        resource_crawler.perform_later(link)
      end
    end
  end
end
