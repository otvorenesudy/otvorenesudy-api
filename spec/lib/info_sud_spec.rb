require 'rails_helper'

RSpec.describe InfoSud do
  let(:downloader) { class_double(InfoSud::Downloader).as_stubbed_const }

  describe '.import_courts' do
    it 'imports courts from url' do
      allow(downloader).to receive(:download_file).with(InfoSud::COURTS_URL) { 'path/to/file' }
      allow(InfoSud).to receive(:import).with('path/to/file', repository: InfoSud::Court)

      InfoSud.import_courts
    end
  end

  describe '.import_judges' do
    it 'imports judges from url' do
      allow(downloader).to receive(:download_file).with(InfoSud::JUDGES_URL) { 'path/to/file' }
      allow(InfoSud).to receive(:import).with('path/to/file', repository: InfoSud::Judge)

      InfoSud.import_judges
    end
  end

  describe '.import_hearings' do
    it 'imports hearings from url' do
      allow(downloader).to receive(:download_file).with(InfoSud::HEARINGS_URL) { 'path/to/file' }
      allow(InfoSud).to receive(:import).with('path/to/file', repository: InfoSud::Hearing)

      InfoSud.import_hearings
    end
  end


  describe '.import_decrees' do
    it 'imports decrees from url' do
      allow(downloader).to receive(:download_file).with(InfoSud::DECREES_URL) { 'path/to/file' }
      allow(InfoSud).to receive(:import).with('path/to/file', repository: InfoSud::Decree)

      InfoSud.import_decrees
    end
  end

  describe '.import' do
    let(:extractor) { class_double(InfoSud::Extractor).as_stubbed_const }
    let(:importer) { class_double(InfoSud::Importer).as_stubbed_const  }
    let(:repository) { double(:repository) }

    it 'imports data from url to repository' do
      allow(extractor).to receive(:extract).with('path/to/file').and_yield('data 1').and_yield('data 2')

      expect(importer).to receive(:import).with('data 1', repository: repository)
      expect(importer).to receive(:import).with('data 2', repository: repository)

      InfoSud.import('path/to/file', repository: repository)
    end
  end
end
