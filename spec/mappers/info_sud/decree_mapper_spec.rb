require 'spec_helper'
require 'info_sud'
require_relative '../../../app/mappers/info_sud/decree_mapper'

RSpec.describe InfoSud::DecreeMapper do
  subject { InfoSud::DecreeMapper.new(data) }

  let(:data) {
    {
      "ecli" => "ECLI:SK:OSMT:2015:5714206355.1",
      "guid" => "99947314-4390-4668-833a-d92ccb476b6b:da85930e-5742-4e33-83d7-7d2f44282b37",
      "sud_typ" => "Okresný súd",
      "sud_guid" => "135",
      "sud_kraj" => "Žilinský kraj",
      "sud_nazov" => "Okresný súd Martin",
      "sud_okres" => "Okres Martin",
      "sudca_guid" => "136",
      "sudca_meno" => "JUDr. Miriam Štillová",
      "dokument_nazov" => "Rozhodnutie_15C-113-2014.pdf",
      "spisova_znacka" => "15C/113/2014",
      "index_timestamp" => "2015-12-02T19:39:33.121Z",
      "sudca_meno_text" => "JUDr. Miriam Štillová",
      "vazby_na_eurlex" => "",
      "dokument_fulltext" => "Fulltext",
      "forma_rozhodnutia" => "Rozhodnutie",
      "nadpis_rozhodnutia" => "",
      "povaha_rozhodnutia" => [
        "Prvostupňové nenapadnuté opravnými prostriedkami"
      ],
      "odkazovane_predpisy" => [
        "/SK/ZZ/2005/36",
        "/SK/ZZ/2005/36/#paragraf-62"
      ],
      "oblast_pravnej_upravy" => [
        "Rodinné právo"
      ],
      "dokument_download_link" => "https://obcan.justice.sk/content/public/item/da85930e-5742-4e33-83d7-7d2f44282b37",
      "odkazovane_predpisy_iri" => "",
      "podoblast_pravnej_upravy" => [
        "Vyživovacie povinnosti"
      ],
      "datum_vydania_rozhodnutia" => "2015-03-08T23:00:00Z",
      "identifikacne_cislo_spisu" => "5714206355",
      "vazby_na_eu_sudne_rozhodnutie" => "",
      "vazby_na_sk_sudne_rozhodnutie" => ""
    }
  }

  describe '#ecli' do
    it 'maps ecli' do
      expect(subject.ecli).to eql('ECLI:SK:OSMT:2015:5714206355.1')
    end
  end

  describe '#uri' do
    it 'maps uri' do
      expect(subject.uri).to eql('https://obcan.justice.sk/infosud/-/infosud/i-detail/rozhodnutie/99947314-4390-4668-833a-d92ccb476b6b:da85930e-5742-4e33-83d7-7d2f44282b37')
    end
  end

  describe '#court' do
    it 'maps court name' do
      expect(subject.court).to eql('Okresný súd Martin')
    end
  end

  describe '#judges' do
    it 'maps judges names' do
      expect(subject.judges).to eql(['JUDr. Miriam Štillová'])
    end
  end

  describe '#case_number' do
    it 'maps case number' do
      expect(subject.case_number).to eql('15C/113/2014')
    end
  end

  describe '#file_number' do
    it 'maps file number' do
      expect(subject.file_number).to eql('5714206355')
    end
  end

  describe '#date' do
    it 'maps decree date' do
      expect(subject.date).to eql(Time.parse('2015-03-08T23:00:00Z'))
    end
  end

  describe '#form' do
    it 'maps decree form' do
      expect(subject.form).to eql('Rozhodnutie')
    end
  end

  describe '#natures' do
    it 'maps decree natures' do
      expect(subject.natures).to eql(['Prvostupňové nenapadnuté opravnými prostriedkami'])
    end
  end

  describe '#legislations' do
    it 'maps legislations' do
      expect(subject.legislations).to eql([
        { year: 2005, number: 36, value: '/SK/ZZ/2005/36', value_unprocessed: '/SK/ZZ/2005/36' },
        { year: 2005, number: 36, paragraph: '62', value: '/SK/ZZ/2005/36/#paragraf-62', value_unprocessed: '/SK/ZZ/2005/36/#paragraf-62' }
      ])
    end
  end

  describe '#legislation_area' do
    it 'maps legislation area' do
      expect(subject.legislation_area).to eql('Rodinné právo')
    end
  end

  describe '#legislation_subarea' do
    it 'maps legislatio subarea' do
      expect(subject.legislation_subarea).to eql('Vyživovacie povinnosti')
    end
  end

  describe '#text' do
    it 'maps text from pdf document' do
      expect(subject.text).to eql('Fulltext')
    end
  end

  describe '#pdf_uri' do
    it 'maps uri to pdf' do
      expect(subject.pdf_uri).to eql('https://obcan.justice.sk/content/public/item/da85930e-5742-4e33-83d7-7d2f44282b37')
    end
  end
end
