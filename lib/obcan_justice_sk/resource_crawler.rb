module ObcanJusticeSk
  module ResourceCrawler
    def downloader
      ObcanJusticeSk::Downloader
    end

    def perform(uri)
      html = downloader.download(uri)
      attributes = parser.parse(html)

      repository.import_from(attributes.merge(uri: uri, source: { html: html }))
    end
  end
end
