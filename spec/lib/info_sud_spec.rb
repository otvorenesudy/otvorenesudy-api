require 'rails_helper'

RSpec.describe InfoSud do
  describe '.import' do
    let(:downloader) { class_double(InfoSud::Downloader).as_stubbed_const }
    let(:extractor) { class_double(InfoSud::Extractor).as_stubbed_const }
    let(:importer) { class_double(InfoSud::Importer).as_stubbed_const  }
    let(:repository) { double(:repository) }

    it 'imports data from url to repository' do
      allow(downloader).to receive(:download_file).with('url') { 'path/to/file' }
      allow(extractor).to receive(:extract).with('path/to/file').and_yield('data 1', 'data 2')

      expect(importer).to receive(:import).with('data 1', repository: repository)
      expect(importer).to receive(:import).with('data 2', repository: repository)

      InfoSud.import('url', repository: repository)
    end
  end
end
