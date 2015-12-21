require 'rails_helper'
require 'models/concerns/importable_spec'

RSpec.shared_examples_for InfoSud::Importable do
  it_behaves_like 'Importable' do
    let(:record) { described_class.find_by(guid: attributes[:guid]) }
    let(:restricted_attributes_for_update) { [] }

    let(:attributes) {
      {
        guid: '1',
        data: {
          guid: '1',
          kraj: 'Bratislavský kraj',
          lattitude: '48.152538',
          internet_address: nil,

          podpredseda: {
            sudcovia: [
              {
                name: "JUDr. Tibor KUBÍK",
                id: "47"
              },
              {
                name: "JUDr. Boris TÓTH",
                id: "582"
              },
              {
                name: "JUDr. Roman BOLEBRUCH",
                id: "588"
              }
            ]
          }
        }
      }
    }

    let(:updated_attributes) { attributes.merge!(
      data: {
        podpredseda: {
          sudcovia: [
            {
              name: "Peter KUBÍK",
              id: "47"
            },
            {
              name: "JUDr. Boris TÓTH",
              id: "582"
            },
            {
              name: "JUDr. Roman BOLEBRUCH",
              id: "588"
            }
          ]
        }
      })
    }
  end
end
