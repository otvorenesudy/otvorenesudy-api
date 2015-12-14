require 'rails_helper'
require 'models/concerns/obcan_justice_sk/importable_spec'

RSpec.describe ObcanJusticeSk::Judge do
  it_behaves_like ObcanJusticeSk::Importable do
    let(:attributes) {
      {
        uri: 'https://obcan.justice.sk/infosud/-/infosud/reg-detail/sudca/sudca_258',
        meno: 'JUDr. Jozef ANGELOVIČ',
        sud: 'Krajský súd v Prešove',
        sud_uri: 'https://obcan.justice.sk/infosud/-/infosud/detail/sud/155',
        docasny_sud: 'Najvyšší súd Slovenskej republiky',
        docasny_sud_uri: 'https://obcan.justice.sk/infosud/-/infosud/detail/sud/100',
        aktivny: true,
        poznamka: nil,
        html: '<html></html>'
      }
    }

    let(:updated_attributes) { attributes.merge(docasny_sud: nil, docasny_sud_uri: nil, aktivny: false) }
  end
end
