require 'rails_helper'

RSpec.describe UnicodeString do
  using UnicodeString

  describe '#strip!' do
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

    context 'when no spaces are removed' do
      it 'returns nil' do
        expect('a'.strip!).to eql(nil)
      end
    end
  end

  context '#strip' do
    it 'delegates to strip!' do
      expect('   a   '.strip).to eql('a')
      expect('   a b   '.strip).to eql('a b')
    end

    context 'when no spaces are removed' do
      it 'returns copy of string' do
        string = 'a'
        stripped = string.strip

        expect(string).to eql(stripped)
        expect(string).not_to equal(stripped)
      end
    end
  end
end
