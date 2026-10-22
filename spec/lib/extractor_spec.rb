# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Extractor do
  let(:archive) { file_fixture('info_sud/example.zip') }

  describe '.extract' do
    it 'extracts and yields all files from zip archive' do
      expect do |block|
        described_class.extract(archive.to_s, &block)
      end.to yield_successive_args("Example File #1\n", "Example File #2\n")
    end

    it 'goes on to the next file when reading one fails' do
      read = []

      described_class.extract(archive.to_s) do |content|
        raise ArgumentError, 'Unreadable file' if content.include?('#1')

        read << content
      end

      expect(read).to eq(["Example File #2\n"])
    end
  end
end
