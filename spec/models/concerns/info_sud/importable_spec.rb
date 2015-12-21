require 'rails_helper'
require 'models/concerns/importable_spec'

RSpec.shared_examples_for InfoSud::Importable do
  it_behaves_like 'Importable' do
    let(:record) { described_class.find_by(guid: attributes[:guid]) }
    let(:restricted_attributes_for_update) { [] }
  end
end
