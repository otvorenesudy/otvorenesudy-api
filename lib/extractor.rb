class Extractor
  def self.extract(path)
    Dir.mkdir(Rails.root.join('tmp', 'extracted')) unless Dir.exist?(Rails.root.join('tmp', 'extracted'))

    directory = Rails.root.join('tmp', 'extracted', "extracted-#{Time.zone.now.to_i}")
    Dir.mkdir(directory)
    begin
      `unzip '#{path}' -d #{directory}`
      Dir[directory.join('*')].each do |filename|
        begin
          yield(File.read(filename))
        rescue StandardError
          nil
        end
      end
    ensure
      FileUtils.rm_rf(directory)
    end
  end
end
