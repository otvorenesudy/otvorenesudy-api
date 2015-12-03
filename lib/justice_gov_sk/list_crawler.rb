module JusticeGovSk
  module ListCrawler
    def parser
      ListParser
    end

    def perform(page:)
      url = uri.build_for(page: page)
      html = JusticeGovSk::Downloader.download(url)
      links = parser.parse(html)

      links.each do |link|
        item_crawler.perform_later(link)
      end
    end
  end
end
