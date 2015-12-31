require 'rails_helper'

RSpec.describe InfoSud::Importer do
  describe '.import' do
    let(:data) { fixture('info_sud/example.json').read }
    let(:parser) { double(:parser) }
    let(:repository) { double(:repository) }

    it 'imports file from path' do
      allow(InfoSud::Downloader).to receive(:download_file).with('url') { :archive }
      allow(InfoSud::Extractor).to receive(:extract).with(:archive).and_yield(data)

      allow(parser).to receive(:parse).with(data) { [{ guid: '1', attribute: 'A' }, { guid: '2', attribute: 'B' }] }

      expect(repository).to receive(:import_from).with(guid: '1', attribute: 'A', url: 'url')
      expect(repository).to receive(:import_from).with(guid: '2', attribute: 'B', url: 'url')

      InfoSud::Importer.import('url', parser: parser, repository: repository)
    end
  end
end
