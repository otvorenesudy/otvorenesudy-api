require 'rails_helper'
require 'models/concerns/info_sud/importable_spec'

RSpec.describe InfoSud::Court do
  it_behaves_like InfoSud::Importable do
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
