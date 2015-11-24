module JusticeGovSk::List
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
