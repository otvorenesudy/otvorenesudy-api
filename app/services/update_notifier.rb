class UpdateNotifier
  def self.notify(record)
    # TODO provide Rest API instead of shared queue later

    client = Sidekiq::Client.new(ConnectionPool.new { Redis.new(url: 'redis://localhost:6379/0') })

    client.push(
      'class' => 'UpdateRepositoryJob',
      'queue' => 'probe',
      'args' => [record.class.name, record.id]
    )
  end
end
