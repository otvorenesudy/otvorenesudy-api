# frozen_string_literal: true

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
        link = document.at_css('a[href^="/extdoc"]:contains("Menný zoznam prokurátorov Slovenskej republiky")')

        "https://www.genpro.gov.sk#{link[:href]}"
      end

      def self.parse_list(xls)
        path = "/tmp/prosecutors-list-#{SecureRandom.hex}"

        File.binwrite(path, xls)

        sheet = Roo::Spreadsheet.open(path, extension: :xls).sheet(0)
        names = (3..sheet.last_row).map do |n|
          parse_name(sheet.row(n)[1])
        end.uniq

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
