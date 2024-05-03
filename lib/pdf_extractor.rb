require 'pdf-reader'
require 'file_downloader'

class PdfExtractor
  def self.extract_text_from_url(url, keep_pdf: false, preserve_pages: false)
    FileDownloader.download(url, directory: '/tmp', keep_file: keep_pdf) do |path|
      reader = PDF::Reader.new(path)

      pages = reader.pages.map(&:text)

      preserve_pages ? pages : pages.join(' ')
    end
  end
end
