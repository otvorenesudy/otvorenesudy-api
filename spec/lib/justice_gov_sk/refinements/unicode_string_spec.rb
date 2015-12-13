require 'spec_helper'
require 'justice_gov_sk'

RSpec.describe JusticeGovSk::Refinements::UnicodeString do
  describe '#strip!' do
    using JusticeGovSk::Refinements::UnicodeString

    it 'removes normal ASCII whitespace' do
      expect('   a   '.strip!).to eql('a')
      expect('   a   '.strip!).to eql('a')
    end

    it 'removes non-breaking whitespace' do
      expect('   a b   '.strip!).to eql('a b')
      expect('   a b   '.strip!).to eql('a b')
      expect('   a   c b   '.strip!).to eql('a   c b')
      expect('   A   b EF   '.strip!).to eql('A   b EF')
    end
  end
end
