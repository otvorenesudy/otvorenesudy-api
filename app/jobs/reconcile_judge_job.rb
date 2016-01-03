class ReconcileJudgeJob < ActiveJob::Base
  queue_as :reconcilers

  def perform(record)
    mapper = record.to_mapper
    judge = Judge.find_or_initialize_by(name: mapper.name)
    reconciler = JudgeReconciler.new(judge, mapper: mapper)

    reconciler.reconcile!
  end
end
