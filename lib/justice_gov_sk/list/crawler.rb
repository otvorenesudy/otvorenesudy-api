module JusticeGovSk::List
  module Crawler
    extend ActiveSupport::Concern

    def perform(page:)
      url = self.class.uri.build_for(page: page)
      html = JusticeGovSk::Downloader.download(url)
      links = Parser.parse(html)

      links.each do |link|
        self.class.resource_crawler.perform_later(link)
      end
    end

    class_methods do
      def pages
        url = uri.build_for(page: 1)

        Parser.parse_pages(JusticeGovSk::Downloader.download(url))
      end
    end
  end
end
