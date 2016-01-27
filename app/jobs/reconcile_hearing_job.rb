class ReconcileHearingJob < ActiveJob::Base
  queue_as :reconcilers

  def perform(record)
    mapper = record.to_mapper
    hearing = HearingFinder.find_by(mapper) || Hearing.new(uri: mapper.uri)
    reconciler = HearingReconciler.new(hearing, mapper: mapper)

    reconciler.reconcile!

    UpdateNotifier.notify(hearing)
  end
end
