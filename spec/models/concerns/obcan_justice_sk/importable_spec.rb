require 'rails_helper'
require 'models/concerns/importable_spec'

RSpec.shared_examples_for ObcanJusticeSk::Importable do
  it_behaves_like 'Importable' do
    let(:record) { described_class.find_by(uri: attributes[:uri]) }
    let(:restricted_attributes_for_update) { [:html] }
  end
end
