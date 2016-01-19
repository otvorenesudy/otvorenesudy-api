require 'curb'

class FileDownloader
  def self.download(uri, directory:)
    content = Curl.get(uri).body_str
    name = Digest::SHA256.hexdigest(content)
    path = File.join(directory, name)

    File.open(path, 'wb') { |f| f.write(content) }

    path
  end
end
