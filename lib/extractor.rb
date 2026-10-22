# frozen_string_literal: true

class Extractor
  def self.extract(path)
    FileUtils.mkdir_p(Rails.root.join('tmp/extracted'))

    directory = Rails.root.join('tmp', 'extracted', "extracted-#{Time.zone.now.to_i}")
    Dir.mkdir(directory)
    begin
      system('unzip', '-qq', path.to_s, '-d', directory.to_s)
      Dir[directory.join('*')].each do |filename|
        yield(File.read(filename))
      rescue StandardError
        nil
      end
    ensure
      FileUtils.rm_rf(directory)
    end
  end
end
