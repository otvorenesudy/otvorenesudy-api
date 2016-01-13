require 'rails_helper'

RSpec.describe 'Import Decrees' do
  context 'from InfoSud' do
    let(:data) { fixture('info_sud/decrees.json').read }
    let(:updated_data) { fixture('info_sud/updated_decrees.json').read }
    let!(:source) { create(:source, module: 'JusticeGovSk') }

    before :each do
      create(:court, name: 'Okresný súd Rožňava')
      create(:court, name: 'Okresný súd Košice I')

      create(:judge, name: 'Mgr. Milan Krak')
      create(:judge, name: 'Mgr. Ján Krak')
    end

    it 'imports decrees' do
      pending

      InfoSud::Importer.import(data, repository: InfoSud::Decree)

      expect(InfoSud::Decree.count).to eql(2)
      expect(Decree.count).to eql(2)

      decree = Decree.find_by(uri: 'https://obcan.justice.sk/infosud/-/infosud/i-detail/rozhodnutie/8db35214-01e6-4ed9-bf10-02f41884dec2:a0ab01fc-955b-4c8b-a3f0-975fe178edeb')
      court = Court.find_by(name: 'Okresný súd Košice I')
      form = Decree::Form.find_by(value: 'Uznesenie')
      area = Legislation::Area.find_by(value: 'Obchodné právo')
      subarea = Legislation::Subarea.find_by(value: 'Iné')
      proceeding = Proceeding.find_by(file_number: '7813210471')
      nature = Decree::Nature.find_by(value: 'Prvostupňové nenapadnuté opravnými prostriedkami')
      judge = Judge.find_by(name: 'Mgr. Ján Krak')
      legislation = Legislation.find_by(number: 224, year: 1996, paragraph: '58', section: '2', letter: 'd')
      page = Decree::Page.find_by(decree: decree, number: 1)

      expect(decree.attributes.symbolize_keys.except(:id, :created_at, :updated_at)).to eql(
        uri: 'https://obcan.justice.sk/infosud/-/infosud/i-detail/rozhodnutie/8db35214-01e6-4ed9-bf10-02f41884dec2:a0ab01fc-955b-4c8b-a3f0-975fe178edeb',
        ecli: 'ECLI:SK:OSRV:2015:7813210471.2',
        case_number: '9Er/1167/2013',
        file_number: '7813210471',
        date: Time.parse('2015-04-12T22:00:00Z'),

        source_id: source.id,
        court_id: court.id,
        decree_form_id: form.id,
        legislation_area_id: area.id,
        legislation_subarea_id: subarea.id,
        proceeding_id: proceeding.id
      )

      expect(decree.natures).to eql([nature])
      expect(decree.judges).to eql([judge])
      expect(decree.legislations).to eql([legislation])
      expect(decree.pages).to eql([page])
    end

    it 'updates decrees' do
      pending

      Timecop.travel(30.minutes.ago) do
        InfoSud::Importer.import(data, repository: InfoSud::Decree)
      end

      updated_at = Time.now

      Timecop.freeze(updated_at) do
        InfoSud::Importer.import(updated_data, repository: InfoSud::Decree)
      end

      decrees = Decree.where('updated_at >= ?', updated_at)

      expect(decrees.size).to eql(1)

      decree = decrees.decree
      court = Court.find_by(name: 'Okresný súd Košice')
      form = Decree::Form.find_by(value: 'Uznesenie')
      area = Legislation::Area.find_by(value: 'Obchodné právo')
      subarea = Legislation::Subarea.find_by(value: 'Incidenčné spory')
      proceeding = Proceeding.find_by(file_number: '7813210471')
      nature = Decree::Nature.find_by(value: 'Prvostupňové nenapadnuté opravnými prostriedkami')
      judge = Judge.find_by(name: 'Mgr. Milan Krak')
      legislation = Legislation.find_by(number: 223, year: 1995, paragraph: '57', section: '1', letter: 'c')
      page = Decree::Page.find_by(decree: decree, number: 1)

      expect(decree.attributes.symbolize_keys.except(:id, :created_at, :updated_at)).to eql(
        uri: 'https://obcan.justice.sk/infosud/-/infosud/i-detail/rozhodnutie/8db35214-01e6-4ed9-bf10-02f41884dec2:a0ab01fc-955b-4c8b-a3f0-975fe178edeb',
        ecli: 'ECLI:SK:OSRV:2015:7813210471.2',
        case_number: '9Er/1167/2013',
        file_number: '7813210471',
        date: Time.parse('2015-04-12T22:00:00Z'),

        source_id: source.id,
        court_id: court.id,
        decree_form_id: form.id,
        legislation_area_id: area.id,
        legislation_subarea_id: subarea.id,
        proceeding_id: proceeding.id
      )

      expect(decree.natures).to eql([nature])
      expect(decree.judges).to eql([judge])
      expect(decree.legislations).to eql([legislation])
      expect(decree.pages).to eql([page])
    end
  end
end
