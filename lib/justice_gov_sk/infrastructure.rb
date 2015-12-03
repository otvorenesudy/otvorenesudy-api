module JusticeGovSk
  module Infrastructure
    # TODO implement async?

    def crawl
      (1..pages).each do |page|
        list_crawler.perform_later(page: page)
      end
    end

    def pages
      url = uri.build_for(page: 1)

      ListParser.parse_pages(JusticeGovSk::Downloader.download(url))
    end
  end
end
