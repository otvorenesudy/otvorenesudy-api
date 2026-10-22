# frozen_string_literal: true

# == Schema Information
#
# Table name: info_sud_courts
#
#  id         :integer          not null, primary key
#  guid       :string           not null
#  data       :jsonb            not null
#  created_at :datetime         not null
#  updated_at :datetime         not null
#
require 'rails_helper'

RSpec.describe InfoSud::Court do
  it_behaves_like InfoSud::Importable

  describe '#to_mapper' do
    it 'maps the record with the InfoSud mapper' do
      record = build(:info_sud_court, data: { 'guid' => '1' })

      expect(record.to_mapper.uri).to eq('https://obcan.justice.sk/infosud/-/infosud/reg-detail/sud/1')
    end
  end

  describe 'after save' do
    let(:record) { build(:info_sud_court) }

    it 'enqueues reconciliation job' do
      expect { record }.not_to have_enqueued_job(ReconcileCourtJob).on_queue('reconcilers')
      expect { record.save! }.to have_enqueued_job(ReconcileCourtJob).with(record).on_queue('reconcilers')
      expect { record.update!({}) }.to have_enqueued_job(ReconcileCourtJob).with(record).on_queue('reconcilers')
    end
  end
end
