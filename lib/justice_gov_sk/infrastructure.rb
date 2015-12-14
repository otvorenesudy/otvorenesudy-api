module JusticeGovSk
  module Infrastructure
    def crawl
      (1..pages).each do |page|
        url = uri.build(page: page)

        list_crawler.perform_later(url)
      end
    end

    def pages
      url = uri.build(page: 1)

      ListParser.parse_pages(JusticeGovSk::Downloader.download(url))
    end
  end
end
