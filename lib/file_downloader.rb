# frozen_string_literal: true

require 'curb'
require 'fileutils'

class FileDownloader
  def self.download(uri, directory:)
    content = Curl.get(uri).body_str
    name = "file-downloader-tmp-file-#{Digest::SHA256.hexdigest(content)}"
    path = File.join(directory, name)

    File.binwrite(path, content)
    result = yield(path)

    FileUtils.rm(path)

    result
  end
end
