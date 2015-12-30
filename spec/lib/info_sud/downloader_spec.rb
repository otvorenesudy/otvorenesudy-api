require 'rails_helper'

RSpec.describe InfoSud::Downloader do
  describe '.download_file' do
    it 'downloads file into tmp/downloads/info_sud' do
      file = double(:file, filename: 'file.txt')

      allow_any_instance_of(Mechanize).to receive(:get).with('http://path/to/file') { file }
      expect(file).to receive(:save!).with(Rails.root.join('tmp/downloads/info_sud/file.txt'))

      InfoSud::Downloader.download_file('http://path/to/file')
    end
  end
end
