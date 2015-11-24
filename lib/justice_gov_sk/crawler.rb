module JusticeGovSk
  module Crawler
    extend ActiveSupport::Concern

    def perform(uri)
      html = self.class.downloader.download(uri)
      attributes = self.class.parser.parse(html)

      self.class.persistor.save(attributes.merge(uri: uri))
    end

    class_methods do
      def downloader
        JusticeGovSk::Downloader
      end
    end
  end
end
