require 'rails_helper'
require 'info_sud'

RSpec.describe InfoSud do
  let(:downloader) { class_double(InfoSud::Downloader).as_stubbed_const }

  describe '.import_courts' do
    it 'imports courts from url' do
      allow(InfoSud::Downloader).to receive(:download_file).with(InfoSud::COURTS_URL) { 'path' }
      allow(InfoSud).to receive(:import).with('path', repository: InfoSud::Court)

      InfoSud.import_courts
    end
  end

  describe '.import_judges' do
    it 'imports judges from url' do
      allow(InfoSud::Downloader).to receive(:download_file).with(InfoSud::JUDGES_URL) { 'path' }
      allow(InfoSud).to receive(:import).with('path', repository: InfoSud::Judge)

      InfoSud.import_judges
    end
  end

  describe '.import_hearings' do
    it 'imports hearings from url' do
      allow(InfoSud::Downloader).to receive(:download_file).with(InfoSud::HEARINGS_URL) { 'path' }
      expect(InfoSud).to receive(:import).with('path', repository: InfoSud::Hearing)

      InfoSud.import_hearings
    end
  end


  describe '.import_decrees' do
    it 'imports decrees from url' do
      allow(InfoSud::Downloader).to receive(:download_file).with(InfoSud::DECREES_URL) { 'path' }
      allow(InfoSud).to receive(:import).with('path', repository: InfoSud::Decree)

      InfoSud.import_decrees
    end
  end

  describe '.import' do
    let(:importer) { class_double(InfoSud::Importer).as_stubbed_const }
    let(:repository) { double(:repository) }

    it 'imports data from url to repository' do
      allow(InfoSud::Extractor).to receive(:extract).with('path').and_yield('Data 1').and_yield('Data 2')

      expect(importer).to receive(:import).with('Data 1', repository: repository)
      expect(importer).to receive(:import).with('Data 2', repository: repository)

      InfoSud.import('path', repository: repository)
    end
  end
end
