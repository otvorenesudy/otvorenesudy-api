require 'rails_helper'

RSpec.describe WelcomePagePresenter do
  subject { WelcomePagePresenter.new(cache: cache) }

  let(:cache) { double(:cache) }

  describe '#decrees_count' do
    it 'caches decrees count' do
      expect(cache).to receive(:fetch).with('decrees_count', expires_in: 12.hours).and_yield
      expect(Decree).to receive(:count)

      subject.decrees_count
    end
  end

  describe '#judges_count' do
    it 'caches judges count' do
      expect(cache).to receive(:fetch).with('judges_count', expires_in: 12.hours).and_yield
      expect(Judge).to receive(:count)

      subject.judges_count
    end
  end

  describe '#hearings_count' do
    it 'caches hearings count' do
      expect(cache).to receive(:fetch).with('hearings_count', expires_in: 12.hours).and_yield
      expect(Hearing).to receive(:count)

      subject.hearings_count
    end
  end
end
