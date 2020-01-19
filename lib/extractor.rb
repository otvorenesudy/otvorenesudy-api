class Extractor
  def self.extract(path)
    Dir.mkdir(Rails.root.join('tmp', 'extracted')) unless Dir.exists?(Rails.root.join('tmp', 'extracted'))

    directory = Rails.root.join('tmp', 'extracted', "extracted-#{Time.zone.now.to_i}")
    Dir.mkdir(directory)
    begin
      `unzip '#{path}' -d #{directory}`
      Dir[directory.join('*')].each do |filename|
        yield(File.read(filename)) rescue nil
      end
    ensure
      FileUtils.rm_rf(directory)
    end
  end
end
