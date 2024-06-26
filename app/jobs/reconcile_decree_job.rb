class ReconcileDecreeJob < ApplicationJob
  queue_as :reconcilers

  def perform(record)
    mapper = record.to_mapper
    decree = DecreeFinder.find_by(mapper) || Decree.new(uri: mapper.uri)
    reconciler = DecreeReconciler.new(decree, mapper: mapper)

    reconciler.reconcile!

    UpdateNotifier.notify(decree)
  end
end
