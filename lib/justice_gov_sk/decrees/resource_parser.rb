module JusticeGovSk::Decrees
  class ResourceParser
    def self.parse(html)
      document = Nokogiri::HTML(html)
      detail = document.css('.detail .inner > .content')[0]

      {
        forma: detail.css('.header h1')[0].text.strip.presence,
        sud: detail.css('.contentTable tr')[0].css('td')[0].text.strip.presence,
        sud_uri: detail.css('.contentTable tr')[0].css('td a')[0][:href].try(:strip).presence,
        sudca: detail.css('.contentTable tr')[1].css('td a')[0].text.strip.presence,
        sudca_uri: detail.css('.contentTable tr')[1].css('td a')[0][:href].try(:strip).presence,
        datum_vydania_rozhodnutia: detail.css('.contentTable tr')[2].css('td')[0].text.strip.presence,
        spisova_znacka: detail.css('.contentTable tr')[4].css('td')[0].text.strip.presence,
        identifikacne_cislo_spisu: detail.css('.contentTable tr')[5].css('td')[0].text.strip.presence,
        oblast_pravnej_upravy: detail.css('.contentTable tr')[6].css('td')[0].text.strip.presence,
        povaha_rozhodnutia: detail.css('.contentTable tr')[7].css('td')[0].text.strip.presence,
        ecli: detail.css('.contentTable tr')[8].css('td')[0].text.strip.presence,
        predpisy: detail.css('.contentTable tr')[9].css('td a').map { |a| a[:'data-iri'].strip },
        pdf_uri: detail.css('#documentWrapper iframe')[0][:src].match(/url=([^&]+)&/)[1],
        html: html
      }
    end
  end
end
