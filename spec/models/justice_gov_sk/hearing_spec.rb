# encoding: UTF-8

require 'rails_helper'
require 'models/concerns/justice_gov_sk/importable_spec'

RSpec.describe JusticeGovSk::Hearing do
  it_behaves_like JusticeGovSk::Importable do
    let(:attributes) {
      {
        uri: 'https://obcan.justice.sk/infosud/-/infosud/i-detail/pojednavanie/5b341263-c6bc-4935-ab25-4fd56b288829',
        predmet: 'PO - určenie neexistencie práva na výkon zrážok zo mzdy',
        sud: 'Okresný súd Žiar n/H',
        sud_uri: 'https://obcan.justice.sk/infosud/-/infosud/detail/sud/146',
        sudca: 'Mgr. Daniel Koneracký',
        sudca_uri: 'https://obcan.justice.sk/infosud/-/infosud/detail/sudca/1749',
        datum: '26.8.2016',
        cas: '09:00',
        usek: 'Civilný',
        spisova_znacka: '18C/19/2014',
        identifikacne_cislo_spisu: '6414201836',
        forma_ukonu: 'Pojednávanie a rozhodnutie',
        poznamka: nil,
        navrhovatelia: [],
        odporcovia: ['Pavol Nový'],
        obzalovani: [],
        miestnost: '32 - 2.poschodie',
        html: '<html></html>'
      }
    }

    let(:updated_attributes) { attributes.merge(cas: '15:00', odporcovia: ['Peter Nový']) }
  end
end
