class ReconcileCourtJob < ActiveJob::Base
  queue_as :reconcilers

  def perform(record)
    mapper = record.to_mapper
    court = Court.find_or_initialize_by(name: mapper.name)
    reconciler = CourtReconciler.new(court, mapper: mapper)

    reconciler.reconcile!
  end
end
