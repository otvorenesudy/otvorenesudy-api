require 'active_support/core_ext/object/blank'
require 'active_job'
require 'nokogiri'

module ObcanJusticeSk
  # TODO rename to namespace ObcanJusticeSk when finished

  require 'obcan_justice_sk/refinements/unicode_string'
  require 'obcan_justice_sk/uri'

  require 'obcan_justice_sk/downloader'
  require 'obcan_justice_sk/list_crawler'
  require 'obcan_justice_sk/resource_crawler'
  require 'obcan_justice_sk/infrastructure'

  require 'obcan_justice_sk/decrees/list_crawler'
  require 'obcan_justice_sk/decrees/resource_parser'
  require 'obcan_justice_sk/decrees/resource_crawler'
  require 'obcan_justice_sk/decrees'

  require 'obcan_justice_sk/hearings/list_crawler'
  require 'obcan_justice_sk/hearings/resource_parser'
  require 'obcan_justice_sk/hearings/resource_crawler'
  require 'obcan_justice_sk/hearings'

  require 'obcan_justice_sk/judges/list_crawler'
  require 'obcan_justice_sk/judges/resource_parser'
  require 'obcan_justice_sk/judges/resource_crawler'
  require 'obcan_justice_sk/judges'

  require 'obcan_justice_sk/courts/list_crawler'
  require 'obcan_justice_sk/courts/resource_parser'
  require 'obcan_justice_sk/courts/resource_crawler'
  require 'obcan_justice_sk/courts'
end
