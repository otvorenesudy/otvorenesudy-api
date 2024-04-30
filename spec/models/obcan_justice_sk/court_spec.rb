# == Schema Information
#
# Table name: obcan_justice_sk_courts
#
#  id         :bigint           not null, primary key
#  guid       :string           not null
#  uri        :string           not null
#  data       :jsonb            not null
#  checksum   :string           not null
#  created_at :datetime         not null
#  updated_at :datetime         not null
#
require 'rails_helper'
require 'models/concerns/obcan_justice_sk/importable_spec'

RSpec.describe ObcanJusticeSk::Court, active_job: { adapter: :test } do
  it_behaves_like ObcanJusticeSk::Importable

  describe 'after save' do
    let(:record) { build(:obcan_justice_sk_court) }

    it 'enqueues reconciliation job' do
      expect { record }.not_to have_enqueued_job(ReconcileCourtJob).on_queue('reconcilers')
      expect { record.save! }.to have_enqueued_job(ReconcileCourtJob).with(record).on_queue('reconcilers')
      expect { record.update!({}) }.to have_enqueued_job(ReconcileCourtJob).with(record).on_queue('reconcilers')
    end
  end
end
