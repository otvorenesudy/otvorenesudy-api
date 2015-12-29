module InfoSud
  class Downloader
    def self.download_file(url)
      agent = Mechanize.new
      file = agent.get(url)

      file.save!(Rails.root.join('tmp/downloads/info_sud', file.filename))
    end
  end
end
