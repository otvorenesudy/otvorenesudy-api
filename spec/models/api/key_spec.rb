# frozen_string_literal: true

require 'rails_helper'

# An API key gets a random value when created, never one another key has.
RSpec.describe Api::Key do
  it 'gets a random value' do
    allow(SecureRandom).to receive(:hex).and_return('0123456789abcdef')

    expect(create(:api_key).value).to eq('0123456789abcdef')
  end

  it 'draws again when the value belongs to another key' do
    allow(SecureRandom).to receive(:hex).and_return('taken', 'taken', 'free')

    create(:api_key)

    expect(create(:api_key).value).to eq('free')
  end
end
