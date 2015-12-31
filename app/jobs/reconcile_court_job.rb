class ReconcileCourtJob < ActiveJob::Base
  queue_as :reconcilers

  def perform(record)
    source = record.to_mapper
    court = Court.find_or_initialize_by(name: source.name)
    reconciler = CourtReconciler.new(source, court)

    reconciler.reconcile

    court.save!
  end
end
