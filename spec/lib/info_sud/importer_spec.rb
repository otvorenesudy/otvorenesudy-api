require 'rails_helper'

RSpec.describe InfoSud::Importer do
  describe '.import' do
    let(:file) { fixture('info_sud/example.json') }
    let(:parser) { double(:parser) }
    let(:repository) { double(:repository) }

    it 'imports file from path' do
      content = file.read

      expect(content.size).to be > 0
      allow(parser).to receive(:parse).with(content) { [{ attribute: 1 }, { attribute: 2 }] }

      expect(repository).to receive(:import_from).with(attribute: 1)
      expect(repository).to receive(:import_from).with(attribute: 2)

      InfoSud::Importer.import(file.path, parser: parser, repository: repository)
    end
  end
end
