require 'rails_helper'

RSpec.describe InfoSud::Extractor do
  let(:archive) { fixture('info_sud/reg-sudy_json.zip') }

  describe '.extract' do
    it 'extracts and yields all files from zip archive' do
      expect { |block|
        InfoSud::Extractor.extract(archive.path, &block)
      }.to yield_control.once
    end
  end
end
