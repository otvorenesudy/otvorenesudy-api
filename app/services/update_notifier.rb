# frozen_string_literal: true

# Tells otvorenesudy to reindex a record this app wrote: pushes UpdateRepositoryJob, with the record's model name and
# id, onto the probe queue in Redis database 0, which otvorenesudy's Sidekiq works. The class, queue, arguments and
# database are a contract with otvorenesudy's app/jobs/update_repository_job.rb.
class UpdateNotifier
  REDIS_URL = 'redis://localhost:6379/0'

  def self.client
    @client ||= Sidekiq::Client.new(pool: Sidekiq::RedisConnection.create(url: REDIS_URL, size: 5))
  end

  def self.notify(record)
    client.push('class' => 'UpdateRepositoryJob', 'queue' => 'probe', 'args' => [record.class.name, record.id])
  end
end
