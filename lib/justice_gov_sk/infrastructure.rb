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

      PagesParser.parse(JusticeGovSk::Downloader.download(url))
    end

    class PagesParser
      def self.parse(html)
        document = Nokogiri::HTML(html)

        document.css('.pager .last a').first[:href].match(/_isufront_WAR_isufront_cur=(\d+)/)[1].to_i
      end
    end
  end
end
