module GenproGovSk
  class PropertyDeclarationsCrawler
    def self.crawl
      prosecutors = GenproGovSk::ProsecutorsCrawler.crawl

      prosecutors.map do |name|
        first_name, last_name = name[:first], name.values_at(:middle, :last).compact.join(' ')

        { name: name, property_declarations: crawl_for(first_name: first_name, last_name: last_name) }
      end
    end

    def self.crawl_for(first_name:, last_name:)
      agent = Mechanize.new
      page = agent.get('https://www.genpro.gov.sk/prokuratura-sr/majetkove-priznania-30a3.html')
      list = page.form_with(name: 'uznesenia-form') { |form|
        form.field_with(name: 'meno').value = first_name
        form.field_with(name: 'priezvisko').value = last_name
      }.submit

      links = Parser.parse(list.body)

      links.map do |url|
        GenproGovSk::PropertyDeclarationCrawler.crawl(url)
      end
    end

    class Parser
      def self.parse(html)
        document = Nokogiri::HTML(html)

        document.css('table.table_01 > tbody > tr > td:nth-child(4) > a').map do |link|
          "https://www.genpro.gov.sk/prokuratura-sr/majetkove-priznania-30a3.html#{link['href']}"
        end
      end
    end
  end
end
