require 'rails_helper'

RSpec.describe ReconcileCourtJob do
  let(:record) { double(:record, to_mapper: mapper) }
  let(:mapper) { double(:mapper, name: 'Krajský súd Bratislava') }
  let(:reconciler) { double(:reconciler)  }
  let(:court) { double(:court) }

  describe '#perform' do
    it 'performs reconciliation for court' do
      allow(Court).to receive(:find_or_initialize_by).with(name: 'Krajský súd Bratislava') { court }
      allow(CourtReconciler).to receive(:new).with(court, mapper: mapper) { reconciler }
      expect(reconciler).to receive(:reconcile!)
      expect(UpdateNotifier).to receive(:notify).with(court)

      ReconcileCourtJob.new.perform(record)
    end
  end

  describe '.perform_later', active_job: { adapter: :test } do
    it 'enqueues record for reconciliation' do
      record = create(:info_sud_court)

      expect {
        ReconcileCourtJob.perform_later(record)
      }.to have_enqueued_job(ReconcileCourtJob).on_queue('reconcilers').with(record)
    end
  end
end
