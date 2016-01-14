class ReconcileDecreeJob < ActiveJob::Base
  queue_as :reconcilers

  def perform(record)
    mapper = record.to_mapper
    decree = DecreeFinder.find_by(mapper) || Decree.new(uri: mapper.uri)
    reconciler = DecreeReconciler.new(decree, mapper: mapper)

    reconciler.reconcile!
  end
end
