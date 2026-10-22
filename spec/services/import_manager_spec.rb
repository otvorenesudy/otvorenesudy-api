# frozen_string_literal: true

require 'rails_helper'

# Saves a source's record only when what it would save differs from what is stored, so an unchanged record doesn't
# enqueue its reconciliation again.
RSpec.describe ImportManager do
  let(:invite) { create(:invite, email: 'peter@example.com', locale: 'sk') }

  describe '.import_or_update' do
    it 'updates the record with attributes that changed' do
      described_class.import_or_update(invite, attributes: { email: 'parker@example.com', locale: 'sk' })

      expect(invite.reload.email).to eq('parker@example.com')
    end

    it 'leaves the record alone when nothing changed' do
      expect { described_class.import_or_update(invite, attributes: { email: 'peter@example.com', locale: 'sk' }) }
        .not_to(change { invite.reload.updated_at })
    end

    it 'leaves the record alone when only attributes it must not update changed' do
      described_class.import_or_update(invite, attributes: { email: 'parker@example.com', locale: 'sk' },
                                               restricted_attributes_for_update: [:email])

      expect(invite.reload.email).to eq('peter@example.com')
    end
  end
end
