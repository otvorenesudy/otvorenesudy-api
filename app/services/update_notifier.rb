class UpdateNotifier
  # TODO provide Rest API instead of shared queue later

  def self.client
    @client ||= Sidekiq::Client.new(pool: ConnectionPool.new { Redis.new(url: 'redis://localhost:6379/0') })
  end

  def self.notify(record)
    client.push('class' => 'UpdateRepositoryJob', 'queue' => 'probe', 'args' => [record.class.name, record.id])
  end
end
