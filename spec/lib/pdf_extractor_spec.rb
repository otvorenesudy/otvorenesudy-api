# frozen_string_literal: true

require 'rails_helper'

RSpec.describe PdfExtractor do
  describe '.extract_text_from_url' do
    context 'with selectable text' do
      let(:url) { 'https://obcan.justice.sk/content/public/item/d377e7ef-a20a-4f93-a031-87994c4d5ad0' }

      it 'extracts text from url', vcr: { cassette_name: 'example.pdf' } do
        text = described_class.extract_text_from_url(url)

        expect(text.length).to be(2480)
        expect(text).to start_with("Súd:                               Okresný súd Spišská Nová Ves\nSpisová značka:")
      end
    end

    context 'with non-selectable text' do
      let(:url) { 'TODO' }

      it 'extracts text from url', vcr: { cassette_name: 'ocr.pdf' } do
        pending 'Requires OCR'

        text = described_class.extract_text_from_url(url)

        expect(text.length).to be(2480)
        expect(text).to start_with('TODO')
      end
    end
  end
end
