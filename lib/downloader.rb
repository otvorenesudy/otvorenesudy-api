class Downloader
  def self.get(url)
    params = extract_params(url)

    10.times do |n|
      begin
        return Curl.get(url, params)
      rescue Exception => e
        warn "Retrying download (#{e.message}) ... ##{n + 1}"

        sleep 5
      end
    end

    raise StandardError.new("Failed to download #{url}")
  end

  def self.extract_params(url)
    match = url.match(/\?(.*)\z/)

    return {} unless match

    Hash[match[1].split('&').map { |s| s.split('=') }]
  end
end
