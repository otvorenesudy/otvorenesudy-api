# frozen_string_literal: true

require 'rails_helper'

# The welcome page's counts of decrees, judges and hearings, cached for 12 hours: counting millions of rows on every
# visit would be slow.
RSpec.describe WelcomePagePresenter do
  subject(:presenter) { described_class.new(cache: ActiveSupport::Cache::MemoryStore.new) }

  it 'counts the decrees, judges and hearings' do
    create_list(:decree, 2)
    create_list(:judge, 3)
    create(:hearing)

    expect([presenter.decrees_count, presenter.judges_count, presenter.hearings_count]).to eq([2, 3, 1])
  end

  it 'counts again only after 12 hours' do
    counts = -> { [presenter.decrees_count, presenter.judges_count, presenter.hearings_count] }
    counts.call
    create(:decree)
    create(:judge)
    create(:hearing)

    expect(counts.call).to eq([0, 0, 0])

    travel 12.hours + 1.second

    expect(counts.call).to eq([1, 1, 1])
  end
end
