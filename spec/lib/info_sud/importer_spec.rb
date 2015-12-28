require 'spec_helper'
require 'info_sud/importer'

RSpec.describe InfoSud::Importer do
  describe '.import' do
    let(:file) { fixture('info_sud/example.json') }
    let(:parser) { double(:parser) }
    let(:repository) { double(:repository) }

    it 'imports file from path' do
      content = file.read

      expect(content.size).to be > 0
      allow(parser).to receive(:parse).with(content) { [{ guid: '1', attribute: 'A' }, { guid: '2', attribute: 'B' }] }

      expect(repository).to receive(:import_from).with(guid: '1', attribute: 'A')
      expect(repository).to receive(:import_from).with(guid: '2', attribute: 'B')

      InfoSud::Importer.import(file.path, parser: parser, repository: repository)
    end
  end
end
