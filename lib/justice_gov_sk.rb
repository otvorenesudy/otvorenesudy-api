require 'active_support/all'
require 'active_job'
require 'nokogiri'

module JusticeGovSk
  autoload :Downloader
  autoload :ListCrawler
  autoload :ResourceCrawler
  autoload :Infrastructure
  autoload :Decrees
end
