require 'curb'

module JusticeGovSk
  class Downloader
    def self.download(uri)
      Curl.get(uri).body_str
    end
  end
end
