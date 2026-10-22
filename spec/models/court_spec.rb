# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Court do
  describe '#judges' do
    it 'lists each judge employed at the court once, however many employments they have there' do
      court = create(:court)
      judge, colleague = create_list(:judge, 2)
      create(:employment, :inactive, court:, judge:)
      create(:employment, :active, court:, judge:)
      create(:employment, :active, court:, judge: colleague)
      create(:employment, :active, judge: create(:judge))

      expect(court.judges).to contain_exactly(judge, colleague)
    end
  end
end
