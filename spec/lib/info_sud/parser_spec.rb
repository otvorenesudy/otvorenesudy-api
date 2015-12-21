require 'spec_helper'
require 'info_sud'

RSpec.describe InfoSud::Parser do
  let(:content) { fixture('info_sud/example.json').read }

  describe '.parse' do
    it 'parses json records' do
      records = InfoSud::Parser.parse(content)

      expect(records.size).to eql(2)
      expect(records.first[:title]).to eql('Example')
    end
  end
end
