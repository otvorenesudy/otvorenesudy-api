module JusticeGovSk
  module ListCrawler
    def perform(page:)
      url = uri.build_for(page: page)
      html = JusticeGovSk::Downloader.download(url)
      links = Parser.parse(html)

      links.each do |link|
        resource_crawler.perform_later(link)
      end
    end

    class Parser
      def self.parse(html)
        document = Nokogiri::HTML(html)

        document.css('.result-list .item h3 a').map { |e| e[:href] }
      end
    end
  end
end
