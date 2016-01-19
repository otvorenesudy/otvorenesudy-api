require 'pdf-reader'
require 'file_downloader'

class PdfExtractor
  def self.extract_text_from_url(url)
    path = FileDownloader.download(url, directory: '/tmp')
    reader = PDF::Reader.new(path)

    reader.pages.map(&:text).join(' ')
  end
end
