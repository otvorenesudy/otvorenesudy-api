# frozen_string_literal: true

class Downloader
  # Tries ten times, waiting between the tries, before it gives up.
  def self.get(url, wait: 5)
    params = extract_params(url)

    10.times do |n|
      return Curl.get(url, params)
    rescue StandardError => e
      warn "Retrying download (#{e.message}) ... ##{n + 1}"

      sleep wait
    end

    raise StandardError, "Failed to download #{url}"
  end

  def self.extract_params(url)
    match = url.match(/\?(.*)\z/)

    return {} unless match

    match[1].split('&').to_h { |s| s.split('=') }
  end
end
