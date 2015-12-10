require 'active_support/core_ext/object/blank'
require 'active_job'
require 'nokogiri'

module JusticeGovSk
  # TODO rename to namespace ObcanJusticeSk when finished

  require 'justice_gov_sk/downloader'
  require 'justice_gov_sk/list_crawler'
  require 'justice_gov_sk/resource_crawler'
  require 'justice_gov_sk/infrastructure'

  require 'justice_gov_sk/decrees/list_crawler'
  require 'justice_gov_sk/decrees/resource_parser'
  require 'justice_gov_sk/decrees/resource_crawler'
  require 'justice_gov_sk/decrees'

  require 'justice_gov_sk/hearings/list_crawler'
  require 'justice_gov_sk/hearings/resource_parser'
  require 'justice_gov_sk/hearings/resource_crawler'
  require 'justice_gov_sk/hearings'

  require 'justice_gov_sk/judges/list_crawler'
  require 'justice_gov_sk/judges/resource_parser'
  require 'justice_gov_sk/judges/resource_crawler'
  require 'justice_gov_sk/judges'

  require 'justice_gov_sk/courts/list_crawler'
  require 'justice_gov_sk/courts/resource_parser'
  require 'justice_gov_sk/courts/resource_crawler'
  require 'justice_gov_sk/courts'

  def self.crawl
    [Courts, Judges, Hearings, Decrees].each do |infrastructure|
      infrastructure.crawl
    end
  end
end
