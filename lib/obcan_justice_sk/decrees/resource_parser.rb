module ObcanJusticeSk::Decrees
  class ResourceParser
    using UnicodeString

    def self.parse(html)
      document = Nokogiri::HTML(html)
      detail = document.css('.detail .inner > .content')[0]

      {
        forma: detail.css('.header h1')[0].text.strip.presence,
        sud: detail.css('.contentTable tr')[0].at_css('td').text.strip.presence,
        sud_uri: detail.css('.contentTable tr')[0].at_css('td a').try(:[], :href).try(:strip).presence,
        sudca: detail.css('.contentTable tr')[1].at_css('td').text.strip.presence,
        sudca_uri: detail.css('.contentTable tr')[1].at_css('td a').try(:[], :href).try(:strip).presence,
        datum: detail.css('.contentTable tr')[2].at_css('td').text.strip.presence,
        spisova_znacka: detail.css('.contentTable tr')[4].at_css('td').text.strip.presence,
        identifikacne_cislo_spisu: detail.css('.contentTable tr')[5].at_css('td').text.strip.presence,
        oblast_pravnej_upravy: detail.css('.contentTable tr')[6].at_css('td').text.strip.presence,
        povaha: detail.css('.contentTable tr')[7].at_css('td').text.strip.presence,
        ecli: detail.css('.contentTable tr')[8].at_css('td').text.strip.presence,
        predpisy: detail.css('.contentTable tr')[9].css('td a').map { |a| a[:'data-iri'].strip },
        pdf_uri: detail.css('#documentWrapper iframe')[0][:src].match(/url=([^&]+)&/)[1]
      }
    end
  end
end
