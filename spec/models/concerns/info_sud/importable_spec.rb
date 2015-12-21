require 'rails_helper'
require 'models/concerns/importable_spec'

RSpec.shared_examples_for InfoSud::Importable do
  it_behaves_like 'Importable' do
    let(:record) { described_class.find_by(guid: attributes[:guid]) }
    let(:restricted_attributes_for_update) { [] }

    # TODO add more descriptive attributes for each model later
    let(:attributes) {
      {
        guid: '1',
        data: {
          guid: '1',
          category: {
            attribute: [
              id: '1',
              name: 'Example'
            ]
          }
        }
      }
    }

    let(:updated_attributes) { attributes.merge!(
      data: {
        guid: '1',
        category: {
          attribute: [
            id: '2',
            name: 'Example'
          ]
        }
      }
    )
    }
  end
end
