class ReconcileHearingJob < ActiveJob::Base
  queue_as :reconcilers

  def perform(record)
    mapper = record.to_mapper
    hearing = HearingFinder.find_by(mapper)
    reconciler = HearingReconciler.new(hearing, mapper: mapper)

    reconciler.reconcile!
  end
end
