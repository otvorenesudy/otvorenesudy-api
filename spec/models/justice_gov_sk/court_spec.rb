require 'rails_helper'
require 'models/concerns/justice_gov_sk/importable_spec'

RSpec.describe JusticeGovSk::Court do
  it_behaves_like JusticeGovSk::Importable do
    let(:attributes) {
      {
        uri: 'https://obcan.justice.sk/infosud/-/infosud/reg-detail/sud/sud_102',
        nazov: 'Okresný súd Bratislava I',
        adresa: 'Záhradnícka 10',
        psc: '81244',
        mesto: 'Bratislava I',
        predseda: 'JUDr. Eva FULCOVÁ',
        predseda_uri: 'https://obcan.justice.sk/infosud/-/infosud/detail/sudca/561',
        podpredseda: ['Mgr. Miriam PLAVČÁKOVÁ'],
        podpredseda_uri: ['https://obcan.justice.sk/infosud/-/infosud/detail/sudca/1767'],
        telefon: '+421288810111',
        fax: '+421255571634',
        image: 'https://obcan.justice.sk/isu-front/prilohy/SUD/102/12.jpg',
        latitude: nil,
        longitude: nil,

        kontaktna_osoba_pre_media: 'Mgr. Pavol Adamčiak',
        telefon_pre_media: '0903 424 263, 02/50118417',
        email_pre_media: nil,
        internetova_stranka_pre_media: nil,

        informacne_centrum_telefonne_cislo: '02/88811200',
        informacne_centrum_email: 'podatelnaosba1@justice.sk',
        informacne_centrum_uradne_hodiny: [
          '8:00 - 15:00',
          '8:00 - 15:00',
          '8:00 - 15:00',
          '8:00 - 15:00',
          '8:00 - 14:00',
        ],
        informacne_centrum_uradne_hodiny_poznamka: nil,

        podatelna_telefonne_cislo: '02/88811180, fax. 02/88811192',
        podatelna_email: 'podatelnaosba1@justice.sk',
        podatelna_uradne_hodiny: [
          '8:00 - 15:30',
          '8:00 - 15:30',
          '8:00 - 15:30',
          '8:00 - 15:30',
          '8:00 - 15:00',
        ],
        podatelna_uradne_hodiny_poznamka: nil,
        html: '<html></html>',

        obchodny_register_telefonne_cislo: '02/501 18 340, 02/501 18 356, 02/501 18 181, 02/501 18 421',
        obchodny_register_email: nil,
        obchodny_register_uradne_hodiny: [
          '8:00 - 15:00',
          '8:00 - 15:00',
          '8:00 - 15:00',
          '8:00 - 15:00',
          '8:00 - 12:00',
        ],
        obchodny_register_uradne_hodiny_poznamka: 'prestávka v práci PO - ŠT: 12:00 - 13:00'
      }
    }

    let(:updated_attributes) { attributes.merge(podpredseda: ['Mgr. Miriam PLAVČÁKOVÁ']) }
  end
end
