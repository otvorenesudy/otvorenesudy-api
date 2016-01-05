require 'spec_helper'

RSpec.describe ReconcileJudgeJob do
  let(:record) { double(:record, to_mapper: mapper) }
  let(:mapper) { double(:mapper, name: 'JUDr. Peter Pan') }
  let(:reconciler) { double(:reconciler)  }
  let(:judge) { double(:judge) }

  describe '#perform' do
    it 'performs reconciliation for judge' do
      allow(Judge).to receive(:find_or_initialize_by).with(name: 'JUDr. Peter Pan') { judge }
      allow(JudgeReconciler).to receive(:new).with(judge, mapper: mapper) { reconciler }
      expect(reconciler).to receive(:reconcile!)

      ReconcileJudgeJob.new.perform(record)
    end
  end

  describe '.perform_later', active_job: { adapter: :test } do
    it 'enqueues judge for reconciliation' do
      record = create(:info_sud_judge)

      expect {
        ReconcileJudgeJob.perform_later(record)
      }.to have_enqueued_job(ReconcileJudgeJob).on_queue('reconcilers').with(record)
    end
  end
end
