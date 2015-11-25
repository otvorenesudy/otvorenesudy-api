module JusticeGovSk
  module ResourceCrawler
    def downloader
      JusticeGovSk::Downloader
    end

    def perform(uri)
      html = downloader.download(uri)
      attributes = parser.parse(html)

      persistor.save(attributes.merge(uri: uri))
    end
  end
end
