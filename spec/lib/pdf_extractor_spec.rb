require 'spec_helper'
require 'pdf_extractor'

RSpec.describe PdfExtractor do
  describe '.extract_text_from_url' do
    let(:url) { 'https://obcan.justice.sk/content/public/item/d377e7ef-a20a-4f93-a031-87994c4d5ad0' }

    it 'extracts text from url', vcr: { cassette_name: 'example.pdf' } do
      text = PdfExtractor.extract_text_from_url(url)

      expect(text.length).to eql(2470)
      expect(text).to start_with("Súd:                              Okresný súd Spišská Nová Ves\nSpisová značka")
    end
  end
end
