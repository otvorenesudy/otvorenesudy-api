module JusticeGovSk
  module ListCrawler
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

    class Parser
      def self.parse(html)
        document = Nokogiri::HTML(html)

        document.css('.result-list .item h3 a').map { |e| e[:href] }
      end

      def self.parse_pages(html)
        document = Nokogiri::HTML(html)

        document.css('.pager .last a').first[:href].match(/_isufront_WAR_isufront_cur=(\d+)/)[1].to_i
      end
    end
  end
end
