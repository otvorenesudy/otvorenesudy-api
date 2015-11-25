require 'active_support/core_ext/object/blank'
require 'active_job'
require 'nokogiri'

module JusticeGovSk
  require 'justice_gov_sk/downloader'
  require 'justice_gov_sk/list_crawler'
  require 'justice_gov_sk/resource_crawler'
  require 'justice_gov_sk/infrastructure'

  require 'justice_gov_sk/decrees/list_crawler'
  require 'justice_gov_sk/decrees/resource_parser'
  require 'justice_gov_sk/decrees/resource_crawler'
  require 'justice_gov_sk/decrees'
end
