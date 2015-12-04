module JusticeGovSk::Hearings
  class ItemParser
    def self.parse(html)
      # TODO parse participants in hearing when available
      # TODO refactor and add more specs

      document = Nokogiri::HTML(html)
      detail = document.css('.detail .right .inner > .content')
      table = detail.at_css('.contentTable')
      children = detail.children[3].children

      {
        predmet: detail.css('.header h1').text.strip.presence,
        sud: table.css('tr')[0].at_css('td').text.strip.presence,
        sud_uri: table.css('tr')[0].at_css('td a').try(:[], :href).try(:strip).presence,
        sudca: table.css('tr')[1].at_css('td').text.strip.presence,
        sudca_uri: table.css('tr')[1].at_css('td a').try(:[], :href).try(:strip).presence,
        datum_pojednavania: table.css('tr')[2].at_css('td').text.strip.presence,
        usek: table.css('tr')[3].at_css('td').text.strip.presence,
        spisova_znacka: table.css('tr')[5].at_css('td').text.strip.presence,
        identifikacne_cislo_spisu: table.css('tr')[6].at_css('td').text.strip.presence,
        forma_ukonu: table.css('tr')[7].at_css('td').text.strip.presence,
        poznamka: table.css('tr')[8].at_css('td').text.strip.presence,
        navrhovatelia: [],
        odporcovia: [],
        obzalovani: [],
        miestnost: children.map { |node| node.text.match(/miestnosť:\s+(.*)/).try(:[], 1) }.compact.first.try(:strip).presence,
        cas_pojednavania: children.map { |node| node.text.match(/\d{1,2}.\d{1,2}.\d{4} o (\d+:\d+)/).try(:[], 1) }.compact.first.try(:strip).presence
      }
    end
  end
end
