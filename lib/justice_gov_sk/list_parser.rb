module JusticeGovSk
  class ListParser
    def self.parse(html)
      document = Nokogiri::HTML(html)

      document.css('.result-list .item h3 a').map { |e| e[:href] }
    end

    def self.parse_pages(html)
      # TODO resolve huge processing time of large htmls!
      document = Nokogiri::HTML(html)

      document.at_css('.pager .last a')[:href].match(/_isufront_WAR_isufront_cur=(\d+)/)[1].to_i
    end
  end
end
