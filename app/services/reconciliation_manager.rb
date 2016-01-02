module ReconciliationManager
  def self.manage(reconciler, record:)
    record.lock!

    reconciler.reconcile

    record.save!
    record.touch
  end
end
