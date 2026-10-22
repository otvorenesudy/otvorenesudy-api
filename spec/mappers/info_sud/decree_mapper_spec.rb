# frozen_string_literal: true

require 'rails_helper'

RSpec.describe InfoSud::DecreeMapper do
  subject(:mapper) { described_class.new(build(:info_sud_decree, id: 1, data:)) }

  let(:data) do
    {
      'ecli' => 'ECLI:SK:OSMT:2015:5714206355.1',
      'guid' => '99947314-4390-4668-833a-d92ccb476b6b:da85930e-5742-4e33-83d7-7d2f44282b37',
      'sud_typ' => 'Okresný súd',
      'sud_guid' => '135',
      'sud_kraj' => 'Žilinský kraj',
      'sud_nazov' => 'Okresný súd Martin',
      'sud_okres' => 'Okres Martin',
      'sudca_guid' => '136',
      'sudca_meno' => 'JUDr. Miriam Štillová',
      'dokument_nazov' => 'Rozhodnutie_15C-113-2014.pdf',
      'spisova_znacka' => '15C/113/2014',
      'index_timestamp' => '2015-12-02T19:39:33.121Z',
      'sudca_meno_text' => 'JUDr. Miriam Štillová',
      'vazby_na_eurlex' => '',
      'dokument_fulltext' => 'Fulltext',
      'forma_rozhodnutia' => 'Rozhodnutie',
      'nadpis_rozhodnutia' => '',
      'povaha_rozhodnutia' => ['Prvostupňové nenapadnuté opravnými prostriedkami'],
      'odkazovane_predpisy' => %w[/SK/ZZ/2005/36 /SK/ZZ/2005/36/#paragraf-62],
      'oblast_pravnej_upravy' => ['Rodinné právo'],
      'dokument_download_link' => 'https://obcan.justice.sk/content/public/item/da85930e-5742-4e33-83d7-7d2f44282b37',
      'odkazovane_predpisy_iri' => '',
      'podoblast_pravnej_upravy' => ['Vyživovacie povinnosti'],
      'datum_vydania_rozhodnutia' => '2015-03-08T23:00:00Z',
      'identifikacne_cislo_spisu' => '5714206355',
      'vazby_na_eu_sudne_rozhodnutie' => '',
      'vazby_na_sk_sudne_rozhodnutie' => ''
    }
  end

  describe '#ecli' do
    it 'maps ecli' do
      expect(mapper.ecli).to eql('ECLI:SK:OSMT:2015:5714206355.1')
    end
  end

  describe '#uri' do
    it 'maps uri' do
      expect(mapper.uri).to eql(
        'https://obcan.justice.sk/infosud/-/infosud/i-detail/rozhodnutie/99947314-4390-4668-833a-d92ccb476b6b:da85930e-5742-4e33-83d7-7d2f44282b37'
      )
    end
  end

  describe '#court' do
    it 'maps court name' do
      expect(mapper.court).to eql('Okresný súd Martin')
    end
  end

  describe '#judges' do
    it 'maps judges by name' do
      judge = create(:judge, name: 'JUDr. Miriam Štillová')

      expect(mapper.judges).to eq([judge])
    end
  end

  describe '#case_number' do
    it 'maps case number' do
      expect(mapper.case_number).to eql('15C/113/2014')
    end
  end

  describe '#file_number' do
    it 'maps file number' do
      expect(mapper.file_number).to eql('5714206355')
    end
  end

  describe '#date' do
    it 'maps decree date' do
      expect(mapper.date).to eq(Time.zone.parse('2015-03-09 00:00'))
    end
  end

  describe '#form' do
    it 'maps decree form' do
      expect(mapper.form).to eql('Rozhodnutie')
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
          { year: 2005, number: 36, value: '/SK/ZZ/2005/36', value_unprocessed: '/SK/ZZ/2005/36' },
          {
            year: 2005,
            number: 36,
            paragraph: '62',
            value: '/SK/ZZ/2005/36/#paragraf-62',
            value_unprocessed: '/SK/ZZ/2005/36/#paragraf-62'
          }
        ]
      )
    end
  end

  describe '#legislation_areas' do
    it 'maps legislation areas' do
      expect(mapper.legislation_areas).to eql(['Rodinné právo'])
    end
  end

  describe '#legislation_subareas' do
    it 'maps legislatio subareas' do
      expect(mapper.legislation_subareas).to eql(['Vyživovacie povinnosti'])
    end
  end

  describe '#pages' do
    it 'maps the text of the document as its one page' do
      expect(mapper.pages).to eq(['Fulltext'])
    end
  end

  describe '#pdf_uri' do
    it 'maps uri to pdf' do
      expect(mapper.pdf_uri).to eql(
        'https://obcan.justice.sk/content/public/item/da85930e-5742-4e33-83d7-7d2f44282b37'
      )
    end
  end

  describe '#form_code' do
    it 'maps the code of the form' do
      expect(mapper.form_code).to eq('A')
    end
  end

  context 'with a record that gives no court, date or form' do
    let(:data) { { 'sud_nazov' => '', 'datum_vydania_rozhodnutia' => '', 'forma_rozhodnutia' => '' } }

    it 'maps none of them' do
      expect([mapper.court, mapper.date, mapper.form_code]).to all(be_nil)
    end
  end
end
