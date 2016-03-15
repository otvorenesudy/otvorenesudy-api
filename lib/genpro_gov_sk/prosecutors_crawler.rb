module GenproGovSk
  class ProsecutorsCrawler
    def self.crawl
      response = Downloader.get('https://www.genpro.gov.sk/extdoc/53851/Menn%FD%20zoznam%20prokur%E1torov%20Slovenskej%20republiky')

      Parser.parse(response.body_str)
    end

    class Parser
      def self.parse(xls)
        path = "/tmp/prosecutors-list-#{SecureRandom.hex}"

        File.open(path, 'wb') { |f| f.write(xls) }

        sheet = Roo::Spreadsheet.open(path, extension: :xls).sheet(0)
        names = (3..sheet.last_row).map do |n|
          parse_name(sheet.row(n)[1])
        end

        FileUtils.rm_r(path)

        names
      end

      def self.parse_name(value)
        parts = Legacy::Normalizer.partition_person_name(value, reverse: true)

        parts.slice(:first, :middle, :last).merge(name: parts[:value])
      end
    end
  end
end
