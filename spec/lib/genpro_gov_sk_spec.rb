require 'spec_helper'
require 'genpro_gov_sk'

RSpec.describe GenproGovSk do
  describe '.export_property_declarations' do
    let(:file) { double(:file) }
    let(:property_declarations) {[
      {
        name: 'Name of Prosecutor',
        property_declarations: []
      }
    ]}

    it 'exports property declarations to a json file' do
      allow(GenproGovSk::PropertyDeclarationsCrawler).to receive(:crawl) { property_declarations }
      allow(File).to receive(:open).with('/path/to/export.json', 'w').and_yield(file)
      expect(file).to receive(:write).with(JSON.pretty_generate(property_declarations))

      GenproGovSk.export_property_declarations(path: '/path/to/export.json')
    end
  end
end
