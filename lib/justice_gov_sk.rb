module JusticeGovSk
  require 'active_support/all'
  require 'active_job'
  require 'nokogiri'

  require 'justice_gov_sk/downloader'
  require 'justice_gov_sk/crawler'
  require 'justice_gov_sk/list_crawler'
  require 'justice_gov_sk/decrees/list_crawler'
  require 'justice_gov_sk/decrees/crawler'
  require 'justice_gov_sk/decrees/parser'
end
