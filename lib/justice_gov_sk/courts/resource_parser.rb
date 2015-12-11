module JusticeGovSk::Courts
  class ResourceParser
    def self.parse(html)
      document = Nokogiri::HTML(html)
      detail = document.css('.detail .right .inner > .content')
      contact = detail.at_css('.contact-address')
      information_center = detail.at_css('.informacne-centrum')
      registry = detail.at_css('.podatelna')
      business_registry = detail.at_css('.orsr')
      coordinates = document.text.scan(/LatLng\("(\d{2}\.\d+)","(\d{2}.\d+)"\)/)[1]

      HTMLCorrector.correct_contact_table(contact.css('table'))

      attributes = {
        nazov: detail.at_css('h1').text.strip.presence,
        adresa: contact.css('.address div')[0].text.strip.presence,
        psc: contact.css('.address div')[1].text.match(/\d+/)[0].strip.presence,
        mesto: contact.css('.address div')[1].text.match(/\d+ (.*)/)[1].strip.presence,
        predseda: detail.at_css('.sud_header_sudcovia').text.strip.presence,
        predseda_uri: detail.at_css('.sud_header_sudcovia a')[:href].strip.presence,
        podpredseda: detail.css('.sud_header_sudcovia')[1].css('a').map { |e| e.text.strip.presence }.compact,
        podpredseda_uri: detail.css('.sud_header_sudcovia')[1].css('a').map { |e| e[:href] }.map { |e| e.strip.presence }.compact,
        telefon: contact.at_css('table').css('tr')[1].css('td')[1].text.strip.presence,
        fax: contact.at_css('table').css('tr')[2].css('td')[1].text.strip.presence,
        image: detail.at_css('.sud-foto img')[:src].strip.presence.tap { |path| path.prepend('https://obcan.justice.sk') },
        latitude: coordinates[0],
        longitude: coordinates[1],

        kontaktna_osoba_pre_media: contact.at_css('table').css('tr')[4].css('td')[1].text.strip.presence,
        telefon_pre_media: contact.at_css('table').css('tr')[5].css('td')[1].text.strip.presence,
        email_pre_media: contact.at_css('table').css('tr')[6].css('td')[1].text.strip.presence,
        internetova_stranka_pre_media: contact.at_css('table').css('tr')[7].css('td')[1].text.strip.presence,

        informacne_centrum_telefonne_cislo: information_center.css('.span6')[0].css('.span8')[0].text.strip.presence,
        informacne_centrum_email: information_center.css('.span6')[0].css('.span8')[1].text.strip.presence,
        informacne_centrum_uradne_hodiny: information_center.css('.span6')[1].css('table').css('tr')[0..4].map { |row|
          row.css('td')[0..1].map { |e| e.text.strip.presence }.compact.join(', ')
        },
        informacne_centrum_uradne_hodiny_poznamka: information_center.css('.span6')[0].css('.row-fluid')[2].text.strip.presence,

        podatelna_telefonne_cislo: registry.css('.span6')[0].css('.span8')[0].text.strip.presence,
        podatelna_email: registry.css('.span6')[0].css('.span8')[1].text.strip.presence,
        podatelna_uradne_hodiny: registry.css('.span6')[1].css('table').css('tr')[0..4].map { |row|
          row.css('td')[0..1].map { |e| e.text.strip.presence }.compact.join(', ')
        },
        podatelna_uradne_hodiny_poznamka: registry.css('.span6')[0].css('.row-fluid')[2].text.strip.presence,
        html: html
      }

      return attributes unless business_registry

      attributes.merge(
        obchodny_register_telefonne_cislo: business_registry.css('.span6')[0].css('.span8')[0].text.strip.presence,
        obchodny_register_email: business_registry.css('.span6')[0].css('.span8')[1].text.strip.presence,
        obchodny_register_uradne_hodiny: business_registry.css('.span6')[1].css('table').css('tr')[0..4].map { |row|
          row.css('td')[0].text.strip.presence
        },
        obchodny_register_uradne_hodiny_poznamka: business_registry.css('.span6')[0].css('.row-fluid')[2].text.strip.presence,
      )
    end

    class HTMLCorrector
      def self.correct_contact_table(table)
        if table.css('tr').size == 6
          return table.at_css('tr').add_next_sibling('<tr><td></td><td></td></tr>' * 2)
        end

        if table.css('tr').size == 7
          if table.at_css('td.emp:contains("Fax")')
            return table.css('tr')[4].add_next_sibling('<tr><td></td><td></td></tr>')
          else
            return table.css('tr')[1].add_next_sibling('<tr><td></td><td></td></tr>')
          end
        end
      end
    end
  end
end
