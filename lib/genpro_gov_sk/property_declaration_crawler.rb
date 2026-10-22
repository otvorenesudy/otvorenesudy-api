# frozen_string_literal: true

module GenproGovSk
  class PropertyDeclarationCrawler
    def self.crawl(url)
      html = Downloader.get(url).body_str

      Parser.parse(html)
    end

    class Parser
      using UnicodeString

      CONTENT = '#page > div.contentIntro > div.grid_9.contentPage'

      def self.parse(html)
        document = Nokogiri::HTML(html)

        {
          year: document.at_css("#{CONTENT} > h3").text.match(/rok (\d+)/)[1].to_i,
          lists: document.search('.table_01').map do |table|
            {
              category: table.at_css('caption').text.strip.presence,
              items: parse_items(table)
            }
          end,
          incomes: parse_incomes(document),
          statements: document.css("#{CONTENT} > div > ol > li").filter_map do |li|
            li.text.strip.presence
          end
        }
      end

      def self.parse_items(table)
        Table.parse(table, parser_factory: lambda { |heading|
          case heading
          when
            ['popis veci', 'dátum nadobudnutia'],
            ['Druh záväzku', 'Dátum nadobudnutia']

            lambda { |row|
              {
                description: row.css('td')[0].text.strip.presence,
                acquisition_date: row.css('td')[1].text.strip.presence
              }
            }
          when
            ['názov/popis', 'dôvod nadobudnutia', 'dátum nadobudnutia'],
            ['popis majetku', 'dôvod nadobudnutia', 'dátum nadobudnutia'],
            ['popis práva', 'právny dôvod nadobudnutia', 'dátum nadobudnutia']

            lambda { |row|
              {
                description: row.css('td')[0].text.strip.presence,
                acquisition_reason: row.css('td')[1].text.strip.presence,
                acquisition_date: row.css('td')[2].text.strip.presence
              }
            }
          end
        })
      end

      def self.parse_incomes(document)
        table = document.at_css('.table_01 > caption:contains(\'Príjmy a iné pôžitky\')').try(:parent)

        return unless table

        Table.parse(table, parser_factory: lambda { |heading|
          if heading == %w[popis príjmy]
            lambda { |row|
              {
                description: row.css('td')[0].text.strip.presence,
                value: row.css('td')[1].text.strip.presence
              }
            }
          end
        })
      end

      class Table
        def self.parse(table, parser_factory:)
          heading = table.css('tr.rowBlue_02 th').filter_map { |th| th.text.strip.presence }
          parser = parser_factory.call(heading)

          return warn("No parser for #{heading}") unless parser

          items = table.search('tr:not(.rowBlue_02)').map do |row|
            parser.call(row)
          end

          items.select { |item| item.try(:compact).present? }
        end
      end
    end
  end
end
