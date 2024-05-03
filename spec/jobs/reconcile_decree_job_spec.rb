require 'rails_helper'

RSpec.describe ReconcileDecreeJob do
  let(:record) { double(:record, to_mapper: mapper) }
  let(:mapper) { double(:mapper, uri: 'uri') }
  let(:reconciler) { double(:reconciler) }
  let(:decree) { double(:decree) }

  describe '#perform' do
    it 'performs reconciliation for decree' do
      allow(DecreeFinder).to receive(:find_by).with(mapper) { decree }
      allow(DecreeReconciler).to receive(:new).with(decree, mapper: mapper) { reconciler }
      expect(reconciler).to receive(:reconcile!)
      expect(UpdateNotifier).to receive(:notify).with(decree)

      ReconcileDecreeJob.new.perform(record)
    end

    context 'when hearing does not exist' do
      it 'initializes new one' do
        allow(DecreeFinder).to receive(:find_by).with(mapper) { nil }
        allow(Decree).to receive(:new).with(uri: 'uri') { decree }
        allow(DecreeReconciler).to receive(:new).with(decree, mapper: mapper) { reconciler }
        expect(reconciler).to receive(:reconcile!)
        expect(UpdateNotifier).to receive(:notify).with(decree)

        ReconcileDecreeJob.new.perform(record)
      end
    end
  end

  describe '.perform_later', active_job: { adapter: :test } do
    it 'enqueues reconciliation job' do
      decree = create(:info_sud_decree)

      expect { ReconcileDecreeJob.perform_later(decree) }.to have_enqueued_job(ReconcileDecreeJob).on_queue(
        'reconcilers'
      ).with(decree)
    end
  end
end
