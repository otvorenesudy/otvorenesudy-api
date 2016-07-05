require 'oj'
require 'roo'
require 'roo-xls'
require 'mechanize'
require 'active_support/all'

require 'legacy'
require 'unicode_string'
require 'downloader'

module GenproGovSk
  require 'genpro_gov_sk/prosecutors_metadata'
  require 'genpro_gov_sk/prosecutors_crawler'
  require 'genpro_gov_sk/property_declaration_crawler'
  require 'genpro_gov_sk/property_declarations_crawler'

  def self.export_property_declarations(path:)
    declarations = PropertyDeclarationsCrawler.crawl

    File.open(path, 'w') do |file|
      file.write(JSON.pretty_generate(declarations))
    end
  end
end
