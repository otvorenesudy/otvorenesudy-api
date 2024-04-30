require 'curb'
require 'fileutils'

class FileDownloader
  def self.download(uri, directory:, keep_file: false, &block)
    content = Curl.get(uri).body_str
    name = "file-downloader-tmp-file-#{Digest::SHA256.hexdigest(content)}"
    path = File.join(directory, name)

    File.open(path, 'wb') { |f| f.write(content) }
    result = block.call(path)

    return result, path if keep_file

    FileUtils.rm(path)

    result
  end
end
