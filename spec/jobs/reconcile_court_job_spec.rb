require 'rails_helper'

RSpec.describe ReconcileCourtJob do
  let(:record) { double(:record, to_mapper: source) }
  let(:source) { double(:source, name: 'Krajský súd v Bratislave') }
  let(:reconciler) { double(:reconciler)  }
  let(:court) { double(:court) }

  describe '#perform' do
    it 'performs reconciliation for court' do
      allow(Court).to receive(:find_or_initialize_by).with(name: 'Krajský súd v Bratislave') { court }
      allow(CourtReconciler).to receive(:new).with(source, court) { reconciler }
      expect(reconciler).to receive(:reconcile)
      expect(court).to receive(:save!)

      ReconcileCourtJob.new.perform(record)
    end
  end

  describe '.perform_later' do
    before :each do
      ActiveJob::Base.queue_adapter = :test
    end

    after :each do
      ActiveJob::Base.queue_adapter = :inline
    end

    it 'enqueues record for reconciliation' do
      record = create(:info_sud_court)

      expect {
        ReconcileCourtJob.perform_later(record)
      }.to have_enqueued_job(ReconcileCourtJob).on_queue('reconcilers').with(record)
    end
  end
end
