require 'curb'
require 'fileutils'

class FileDownloader
  def self.download(uri, directory:, &block)
    content = Curl.get(uri).body_str
    name = "file-downloader-tmp-file-#{Digest::SHA256.hexdigest(content)}"
    path = File.join(directory, name)

    File.open(path, 'wb') { |f| f.write(content) }
    result = block.call(path)

    FileUtils.rm(path)

    result
  end
end
