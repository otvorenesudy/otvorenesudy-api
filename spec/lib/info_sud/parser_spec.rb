# frozen_string_literal: true

require 'rails_helper'

RSpec.describe InfoSud::Parser do
  let(:content) { file_fixture('info_sud/example.json').read }

  describe '.parse' do
    it 'parses json records' do
      records = described_class.parse(content)

      expect(records.size).to be(2)
      expect(records.first[:title]).to eql('Example')
    end
  end
end
