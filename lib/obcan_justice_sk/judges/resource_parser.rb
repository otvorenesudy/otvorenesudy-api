module ObcanJusticeSk::Judges
  class ResourceParser
    using UnicodeString

    def self.parse(html)
      document = Nokogiri::HTML(html)
      detail = document.css('.detail .right .inner > .content')

      {
        meno: detail.at_css('h1').text.strip.presence,
        sud: detail.at_css('h5 a').text.strip.presence,
        sud_uri: detail.at_css('h5 a')[:href].strip.presence,
        aktivny: !!detail.at_css('.sudca_stav span.state.active'),
        docasny_sud: detail.css('h5 a')[1].try(:text).try(:strip).presence,
        docasny_sud_uri: detail.css('h5 a')[1].try(:[], :href).try(:strip).presence,
        poznamka: detail.at_css('.sudca_stav').next.try(:text).strip.presence
      }
    end
  end
end
