class UpdateNotifier
  def self.notify(record)
    # TODO provide Rest API instead of shared queue later

    Sidekiq::Client.push(
      'class' => 'UpdateRepositoryJob',
      'queue' => 'probe',
      'args' => [record.class.name, record.id]
    )
  end
end
