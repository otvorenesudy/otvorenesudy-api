require 'spec_helper'
require 'obcan_justice_sk'
require 'pdf_extractor'
require 'sentry-ruby'
require_relative '../../../app/mappers/obcan_justice_sk/decree_mapper'

RSpec.describe ObcanJusticeSk::DecreeMapper do
  subject { described_class.new(double(:decree, id: 1, class: double(:class, name: 'Decree'), data: data)) }

  let(:data) { JSON.parse(fixture('obcan_justice_sk/mappers/decree.json').read) }

  describe '#source' do
    it 'maps source' do
      expect(subject.source).to eql('JusticeGovSk')
    end
  end

  describe '#source_class' do
    it 'maps source class' do
      expect(subject.source_class).to eql('Decree')
    end
  end

  describe '#source_class_id' do
    it 'maps source class id' do
      expect(subject.source_class_id).to eql(1)
    end
  end

  describe '#ecli' do
    it 'maps ecli' do
      expect(subject.ecli).to eql('ECLI:SK:OSLC:2021:6120386527.2')
    end
  end

  describe '#uri' do
    it 'maps uri' do
      expect(subject.uri).to eql(
        'https://www.justice.gov.sk/sudy-a-rozhodnutia/sudy/rozhodnutia/819aef78-bdd4-4855-b8ed-d936446d41a2:3855d4dc-1209-4ddf-8a63-34cb3349cede'
      )
    end
  end

  describe '#court' do
    it 'maps court name' do
      expect(subject.court).to eql('Okresný súd Lučenec')
    end
  end

  describe '#judges' do
    it 'maps judges names' do
      expect(subject.judges).to eql(['JUDr. Andrea Gabrielová'])
    end
  end

  describe '#case_number' do
    it 'maps case number' do
      expect(subject.case_number).to eql('17Csp/50/2021')
    end
  end

  describe '#file_number' do
    it 'maps file number' do
      expect(subject.file_number).to eql('6120386527')
    end
  end

  describe '#date' do
    it 'maps decree date' do
      expect(subject.date).to eql(Time.parse('2021-05-27'))
    end
  end

  describe '#form' do
    it 'maps decree form' do
      expect(subject.form).to eql('Rozsudok')
    end
  end

  describe '#natures' do
    it 'maps decree natures' do
      expect(subject.natures).to eql(['Prvostupňové nenapadnuté opravnými prostriedkami'])
    end
  end

  describe '#legislations' do
    it 'maps legislations' do
      expect(subject.legislations).to eql(
        [
          { number: 40, value: '/SK/ZZ/1964/40', value_unprocessed: '/SK/ZZ/1964/40', year: 1964 },
          {
            number: 40,
            paragraph: '52',
            section: '1',
            value: '/SK/ZZ/1964/40/#paragraf-52.odsek-1',
            value_unprocessed: '/SK/ZZ/1964/40/#paragraf-52.odsek-1',
            year: 1964
          },
          {
            number: 40,
            paragraph: '52',
            section: '2',
            value: '/SK/ZZ/1964/40/#paragraf-52.odsek-2',
            value_unprocessed: '/SK/ZZ/1964/40/#paragraf-52.odsek-2',
            year: 1964
          },
          {
            number: 40,
            paragraph: '517',
            section: '1',
            value: '/SK/ZZ/1964/40/#paragraf-517.odsek-1',
            value_unprocessed: '/SK/ZZ/1964/40/#paragraf-517.odsek-1',
            year: 1964
          },
          {
            number: 40,
            paragraph: '517',
            section: '2',
            value: '/SK/ZZ/1964/40/#paragraf-517.odsek-2',
            value_unprocessed: '/SK/ZZ/1964/40/#paragraf-517.odsek-2',
            year: 1964
          },
          {
            number: 300,
            paragraph: '289',
            section: '1',
            value: '/SK/ZZ/2005/300/#paragraf-289.odsek-1',
            value_unprocessed: '/SK/ZZ/2005/-300/#paragraf-289.odsek-1',
            year: 2005
          }
        ]
      )
    end
  end

  describe '#legislation_areas' do
    it 'maps legislation areas' do
      expect(subject.legislation_areas).to eql(['Občianske právo'])
    end
  end

  describe '#legislation_subareas' do
    it 'maps legislatio subarea' do
      expect(subject.legislation_subareas).to eql(['Spotrebiteľské zmluvy'])
    end
  end

  describe '#pages' do
    it 'maps pages from pdf document to text pages and caches pdf extractor response' do
      allow(PdfExtractor).to receive(:extract_text_from_url)
        .with(subject.pdf_uri, preserve_pages: true)
        .and_return(['Fulltext'])
        .once

      expect(subject.pages).to eql(['Fulltext'])
      expect(subject.pages).to eql(['Fulltext'])
    end

    context 'when pdf is not available' do
      it 'returns empty array' do
        error = StandardError.new()

        allow(PdfExtractor).to receive(:extract_text_from_url).with(subject.pdf_uri, preserve_pages: true).and_raise(
          error
        )

        expect(Sentry).to receive(:capture_exception).with(error).once

        expect(subject.pages).to eql([])
      end
    end

    context 'when pdf is empty' do
      it 'returns empty array' do
        allow(PdfExtractor).to receive(:extract_text_from_url).with(subject.pdf_uri, preserve_pages: true).and_return(
          []
        )

        expect(Sentry).to receive(:capture_exception) do |error|
          error.message === 'Failed to extract text from PDF for Decree:1'
        end

        expect(subject.pages).to eql([])
      end
    end
  end

  describe '#pdf_uri' do
    it 'maps uri to pdf' do
      expect(subject.pdf_uri).to eql(
        'https://obcan.justice.sk/content/public/item/3855d4dc-1209-4ddf-8a63-34cb3349cede'
      )
    end
  end
end
