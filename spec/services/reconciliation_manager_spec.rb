require 'spec_helper'
require_relative '../../app/services/reconciliation_manager'

RSpec.describe ReconciliationManager do
  describe '.manage' do
    let(:reconciler) { double(:reconciler) }
    let(:record) { double(:record) }

    it 'manages reconcilition logic for concrete reconciler and record' do
      expect(record).to receive(:lock!)
      expect(reconciler).to receive(:reconcile)
      expect(record).to receive(:save!)
      expect(record).to receive(:touch)

      ReconciliationManager.manage(reconciler, record: record)
    end
  end
end
