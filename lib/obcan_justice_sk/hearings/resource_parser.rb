module ObcanJusticeSk::Hearings
  class ResourceParser
    using ObcanJusticeSk::Refinements::UnicodeString

    def self.parse(html)
      # TODO parse participants in hearing when available

      document = Nokogiri::HTML(html)
      detail = document.css('.detail .right .inner > .content')
      table = detail.at_css('.contentTable')
      children = detail.children[5].children

      HtmlCorrector.correct_judge_row(table)

      date_with_time = table.css('tr')[2].at_css('td').text.strip

      {
        predmet: detail.at_css('.header h1').text.strip.presence,
        sud: table.css('tr')[0].at_css('td').text.strip.presence,
        sud_uri: table.css('tr')[0].at_css('td a').try(:[], :href).try(:strip).presence,
        sudca: table.css('tr')[1].at_css('td').text.strip.presence,
        sudca_uri: table.css('tr')[1].at_css('td a').try(:[], :href).try(:strip).presence,
        datum: date_with_time.match(/\d+\.\d+\.\d{4}/)[0],
        cas: date_with_time.match(/o (\d+:\d+)/)[1],
        usek: table.css('tr')[3].at_css('td').text.strip.presence,
        spisova_znacka: table.css('tr')[5].at_css('td').text.strip.presence,
        identifikacne_cislo_spisu: table.css('tr')[6].at_css('td').text.strip.presence,
        forma_ukonu: table.css('tr')[7].at_css('td').text.strip.presence,
        poznamka: table.css('tr')[8].at_css('td').text.strip.presence,
        navrhovatelia: [],
        odporcovia: [],
        obzalovani: [],
        miestnost: children.map { |node| node.text.match(/miestnosť:\s+(.*)/).try(:[], 1) }.compact.first.try(:strip).presence,
        html: html
      }
    end

    class HtmlCorrector
      def self.correct_judge_row(table)
        unless table.at_css('tr th:contains("Sudca:")')
          table.at_css('tr').add_next_sibling('<tr><th></th><td></td></tr>')
        end
      end
    end
  end
end
