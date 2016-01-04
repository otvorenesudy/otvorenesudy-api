require 'spec_helper'
require 'info_sud'

RSpec.describe InfoSud::Extractor do
  let(:archive) { fixture('info_sud/example.zip') }

  describe '.extract' do
    it 'extracts and yields all files from zip archive' do
      expect { |block|
        InfoSud::Extractor.extract(archive.path, &block)
      }.to yield_successive_args("Example File #1\n", "Example File #2\n")
    end
  end
end
