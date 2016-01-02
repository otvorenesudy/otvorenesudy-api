class ReconcileCourtJob < ActiveJob::Base
  queue_as :reconcilers

  def perform(record)
    mapper = record.to_mapper
    court = Court.find_or_initialize_by(name: mapper.name)
    reconciler = CourtReconciler.new(mapper, court)

    reconciler.reconcile

    court.save!
    court.touch
  end
end
