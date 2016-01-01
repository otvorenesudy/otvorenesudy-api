module ActiveJobHelper
  def perform_enqueued_jobs
    queue_adapter = ActiveJob::Base.queue_adapter

    old_perform_enqueued_jobs = queue_adapter.perform_enqueued_jobs
    old_perform_enqueued_at_jobs = queue_adapter.perform_enqueued_at_jobs

    begin
      queue_adapter.perform_enqueued_jobs = true
      queue_adapter.perform_enqueued_at_jobs = true
      yield
    ensure
      queue_adapter.perform_enqueued_jobs = old_perform_enqueued_jobs
      queue_adapter.perform_enqueued_at_jobs = old_perform_enqueued_at_jobs
    end
  end
end
