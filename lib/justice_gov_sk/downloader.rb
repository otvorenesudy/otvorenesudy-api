require 'curb'

module JusticeGovSk
  class Downloader
    def self.headers
      @headers ||= {
        'Accept'          => 'text/html,application/xhtml+xml,application/xml;q=0.9,*/*;q=0.8',
        'Accept-Language' => 'en-US,en;q=0.5',
        'Cache-Control'   => 'max-age=0',
        'Connection'      => 'keep-alive',
        'User-Agent'      => 'Mozilla/5.0 (X11; Ubuntu; Linux x86_64; rv:16.0) Gecko/20100101 Firefox/16.0'
      }
    end

    def self.download(url, options = {})
      response = Curl.get(url) do |curl|
        curl.follow_location = true
        curl.headers = headers.merge(options[:headers] || {})
      end

      if response.response_code != 200
        raise StandardError.new("Response code #{response.response_code}.")
      end

      response.body_str
    end
  end
end
