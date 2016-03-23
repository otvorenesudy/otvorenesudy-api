module GenproGovSk
  class ProsecutorsCrawler
    def self.crawl
      page = Downloader.get('https://www.genpro.gov.sk/prokuratura-sr/menny-zoznam-prokuratorov-slovenskej-republiky-3928.html').body_str
      url = Parser.parse_link(page)
      xls = Downloader.get(url).body_str

      Parser.parse_list(xls)
    end

    class Parser
      def self.parse_link(html)
        document = Nokogiri::HTML(html)
        fragment = document.at_css('a[href^="/extdoc"]:contains("Menný zoznam prokurátorov Slovenskej republiky")')[:href]

        "https://www.genpro.gov.sk#{fragment}"
      end

      def self.parse_list(xls)
        path = "/tmp/prosecutors-list-#{SecureRandom.hex}"

        File.open(path, 'wb') { |f| f.write(xls) }

        sheet = Roo::Spreadsheet.open(path, extension: :xls).sheet(0)
        names = (3..sheet.last_row).map { |n|
          parse_name(sheet.row(n)[1])
        }.uniq

        FileUtils.rm_r(path)

        names
      end

      def self.parse_name(value)
        parts = Legacy::Normalizer.partition_person_name(value, reverse: true)

        parts.slice(:value, :first, :middle, :last)
      end
    end
  end
end
