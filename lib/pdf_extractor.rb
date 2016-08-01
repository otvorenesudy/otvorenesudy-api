require 'pdf-reader'
require 'file_downloader'

class PdfExtractor
  def self.extract_text_from_url(url)
    FileDownloader.download(url, directory: '/tmp') do |path|
      reader = PDF::Reader.new(path)

      reader.pages.map(&:text).join(' ')
    end
  end
end
