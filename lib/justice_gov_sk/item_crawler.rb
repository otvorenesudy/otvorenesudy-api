module JusticeGovSk
  module ItemCrawler
    def downloader
      JusticeGovSk::Downloader
    end

    def perform(uri)
      html = downloader.download(uri)
      attributes = parser.parse(html)

      repository.import_from(attributes.merge(uri: uri))
    end
  end
end
