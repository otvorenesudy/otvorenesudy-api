require 'spec_helper'

RSpec.describe ReconcileHearingJob do
  let(:record) { double(:record, to_mapper: mapper) }
  let(:mapper) { double(:mapper, uri: 'uri') }
  let(:reconciler) { double(:reconciler) }
  let(:hearing) { double(:hearing) }

  describe '#perform' do
    it 'performs reconciliation for hearing' do
      allow(HearingFinder).to receive(:find_by).with(mapper) { hearing }
      allow(HearingReconciler).to receive(:new).with(hearing, mapper: mapper) { reconciler }
      expect(reconciler).to receive(:reconcile!)

      ReconcileHearingJob.new.perform(record)
    end

    context 'when hearing does not exist' do
      it 'initializes new one' do
        allow(HearingFinder).to receive(:find_by).with(mapper) { nil }
        allow(Hearing).to receive(:new).with(uri: 'uri') { hearing }
        allow(HearingReconciler).to receive(:new).with(hearing, mapper: mapper) { reconciler }
        expect(reconciler).to receive(:reconcile!)

        ReconcileHearingJob.new.perform(record)
      end
    end
  end

  describe '.perform_later', active_job: { adapter: :test } do
    it 'enqueues reconciliation job' do
      hearing = create(:info_sud_hearing)

      expect {
        ReconcileHearingJob.perform_later(hearing)
      }.to have_enqueued_job(ReconcileHearingJob).on_queue('reconcilers').with(hearing)
    end
  end
end
