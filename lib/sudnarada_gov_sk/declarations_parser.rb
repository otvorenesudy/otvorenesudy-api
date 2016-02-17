module SudnaradaGovSk
  using UnicodeString

  class DeclarationsParser
    def self.parse(xml)
      document = Nokogiri::XML(xml)

      document.search('Priznania > Sudca').map do |node|
        {
          year: node.search('Rok').text.to_i,
          court: Legacy::Normalizer.normalize_court_name(node.at_css('Sud').text.strip),
          judge: parse_normalized_name(node),
          lists: parse_lists(node),
          incomes: node.search('Prijmy > Prijem').map { |e|
            item = parse_item(e)

            { description: item[:description], value: item[:cost] }
          },
          related_people: node.search('Blizke_osoby > Blizka_osoba').map { |e|
            {
              name: parse_normalized_name(e),
              name_unprocessed: parse_name(e),
              institution: Legacy::Normalizer.normalize_court_name(e.at_css('Institucia').try(:text).try(:strip)),
              function: e.at_css('Funkcia').try(:text).try(:strip)
            }
          }
        }
      end
    end

    def self.parse_normalized_name(node)
      Legacy::Normalizer.normalize_person_name(parse_name(node))
    end

    def self.parse_name(node)
      parts = ['Titul_pred', 'Meno', 'Priezvisko', 'Titul_za']

      parts.map { |part| node.at_css(part).try(:text).try(:strip) }.compact.join(' ').strip
    end

    def self.parse_lists(node)
      lists = {
        'Zoznam nehnuteľností' => node.search('Nehnutelnosti > Nehnutelnost'),
        'Hnuteľné veci' => node.search('Hnutelnosti > Hnutelnost'),
        'Majetkové práva' => node.search('Majektove_prava > Majektove_pravo'),
        'Príjem z výkonu funkcie sudcu' => node.search('Prijmy > Prijem'),
        'Peňažné záväzky' => node.search('Zavazky > Zavazok'),
        'Súbor hnuteľných vecí a majetkových práv' => node.search('Subory_hnut_veci_prav > Subor_hnut_veci_prav'),
      }

      lists.map do |category, list|
        {
          category: category,
          items: list.map { |item| parse_item(item) }
        }
      end
    end

    def self.parse_item(node)
      {
        description: node.at_css('Nazov').text.strip,
        acquisition_reason: node.at_css('Dovod_nadob').text.strip,
        acquisition_date: node.at_css('Datum_nadob').text.strip,
        cost: node.at_css('Cena').text.to_i,
        share_size: node.at_css('Podiel').text.strip,
        ownership_form: node.at_css('Vlastnictvo').text.strip,
        change: node.at_css('Zmena').try(:text).try(:strip)
      }
    end
  end
end
