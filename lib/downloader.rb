class Downloader
  def self.get(url)
    10.times do |n|
      begin
        return Curl.get(url)
      rescue Exception => e
        warn "Retrying download (#{e.message}) ... ##{n + 1}"

        sleep 5
      end
    end

    raise StandardError.new("Failed to download #{url}")
  end
end
