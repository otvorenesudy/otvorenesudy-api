# frozen_string_literal: true

require 'rails_helper'

RSpec.describe ObcanJusticeSk::DecreeMapper do
  subject(:mapper) { described_class.new(build(:obcan_justice_sk_decree, id: 1, data:)) }

  let(:data) { JSON.parse(file_fixture('obcan_justice_sk/mappers/decree.json').read) }

  describe '#source' do
    it 'maps source' do
      expect(mapper.source).to eql('JusticeGovSk')
    end
  end

  describe '#source_class' do
    it 'maps source class' do
      expect(mapper.source_class).to eq('ObcanJusticeSk::Decree')
    end
  end

  describe '#source_class_id' do
    it 'maps source class id' do
      expect(mapper.source_class_id).to be(1)
    end
  end

  describe '#ecli' do
    it 'maps ecli' do
      expect(mapper.ecli).to eql('ECLI:SK:OSLC:2021:6120386527.2')
    end
  end

  describe '#uri' do
    it 'maps uri' do
      expect(mapper.uri).to eql(
        'https://www.justice.gov.sk/sudy-a-rozhodnutia/sudy/rozhodnutia/819aef78-bdd4-4855-b8ed-d936446d41a2:3855d4dc-1209-4ddf-8a63-34cb3349cede'
      )
    end
  end

  describe '#court' do
    it 'maps court name' do
      expect(mapper.court).to eql('Okresný súd Lučenec')
    end
  end

  describe '#judges' do
    it 'maps judges by the id obcan.justice.sk gives them' do
      raw = create(:obcan_justice_sk_judge, guid: data['sudca']['registreGuid'])
      judge = create(:judge, source_class: 'ObcanJusticeSk::Judge', source_class_id: raw.id)

      expect(mapper.judges).to eq([judge])
    end
  end

  describe '#case_number' do
    it 'maps case number' do
      expect(mapper.case_number).to eql('17Csp/50/2021')
    end
  end

  describe '#file_number' do
    it 'maps file number' do
      expect(mapper.file_number).to eql('6120386527')
    end
  end

  describe '#date' do
    it 'maps decree date' do
      expect(mapper.date).to eq(Date.new(2021, 5, 27))
    end
  end

  describe '#form' do
    it 'maps decree form' do
      expect(mapper.form).to eql('Rozsudok')
    end
  end

  describe '#natures' do
    it 'maps decree natures' do
      expect(mapper.natures).to eql(['Prvostupňové nenapadnuté opravnými prostriedkami'])
    end
  end

  describe '#legislations' do
    it 'maps legislations' do
      expect(mapper.legislations).to eql(
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
      expect(mapper.legislation_areas).to eql(['Občianske právo'])
    end
  end

  describe '#legislation_subareas' do
    it 'maps legislatio subarea' do
      expect(mapper.legislation_subareas).to eql(['Spotrebiteľské zmluvy'])
    end
  end

  describe '#pages' do
    before { allow(Sentry).to receive(:capture_exception) }

    it 'maps the pages of the document to their text, fetching it once' do
      stub_request(:get, mapper.pdf_uri).to_return(body: file_fixture('pdf/normal.pdf').binread)

      expect([mapper.pages, mapper.pages]).to eq([['Dummy PDF file'], ['Dummy PDF file']])
      expect(a_request(:get, mapper.pdf_uri)).to have_been_made.once
    end

    context 'when the document is not available' do
      it 'maps no pages, and reports the error' do
        stub_request(:get, mapper.pdf_uri).to_timeout

        expect(mapper.pages).to eq([])
        expect(Sentry).to have_received(:capture_exception).with(an_instance_of(Curl::Err::TimeoutError))
      end
    end

    context 'when the document has no text' do
      it 'maps no pages, and reports the decree' do
        stub_request(:get, mapper.pdf_uri).to_return(body: file_fixture('pdf/ocr.pdf').binread)

        expect(mapper.pages).to eq([])
        expect(Sentry).to have_received(:capture_exception)
          .with(having_attributes(message: 'Failed to extract text from PDF for ObcanJusticeSk::Decree:1'))
      end
    end
  end

  describe '#pdf_uri' do
    it 'maps uri to pdf' do
      expect(mapper.pdf_uri).to eql(
        'https://obcan.justice.sk/content/public/item/3855d4dc-1209-4ddf-8a63-34cb3349cede'
      )
    end
  end

  context 'with a record that gives no form' do
    let(:data) { JSON.parse(file_fixture('obcan_justice_sk/mappers/decree.json').read).except('formaRozhodnutia') }

    it 'maps no form code' do
      expect(mapper.form_code).to be_nil
    end
  end
end
