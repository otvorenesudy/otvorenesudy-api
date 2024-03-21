require 'spec_helper'
require 'info_sud'

RSpec.describe InfoSud::Importer do
  describe '.import' do
    let(:data) { fixture('info_sud/example.json').read }
    let(:parser) { double(:parser) }
    let(:repository) { double(:repository) }

    it 'imports file from path' do
      allow(parser).to receive(:parse).with(data) { [{ guid: '1', attribute: 'A' }, { guid: '2', attribute: 'B' }] }

      expect(repository).to receive(:import_from).with({ guid: '1', attribute: 'A' })
      expect(repository).to receive(:import_from).with({ guid: '2', attribute: 'B' })

      InfoSud::Importer.import(data, parser: parser, repository: repository)
    end
  end
end
