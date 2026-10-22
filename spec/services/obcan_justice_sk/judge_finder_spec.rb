# frozen_string_literal: true

require 'rails_helper'

RSpec.describe ObcanJusticeSk::JudgeFinder do
  let!(:obcan_justice_sk_judge) { create(:obcan_justice_sk_judge, guid: '123') }
  let!(:judge) { create(:judge, source_class: 'ObcanJusticeSk::Judge', source_class_id: obcan_justice_sk_judge.id) }
  let!(:other_judge) { create(:judge, name: 'JUDr. Peter Smith') }

  describe '.find_by' do
    context 'when guid is present' do
      it 'finds judge by guid' do
        expect(described_class.find_by(name: 'JUDr. Peter Pan, PhD.', guid: '123')).to eq(judge)
      end
    end

    context 'when guid is not present' do
      it 'finds judge by name' do
        expect(described_class.find_by(name: 'JUDr. Peter Smith', guid: nil)).to eq(other_judge)
      end
    end

    context 'when judge is not found' do
      it 'returns nil' do
        expect(described_class.find_by(name: 'JUDr. Peter Plan', guid: nil)).to be_nil
      end
    end
  end
end
