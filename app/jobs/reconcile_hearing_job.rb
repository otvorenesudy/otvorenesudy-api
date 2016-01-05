class ReconcileHearingJob < ActiveJob::Base
  queue_as :reconcilers

  def perform(record)
    # TODO
  end
end
