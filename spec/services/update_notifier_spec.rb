# frozen_string_literal: true

require 'rails_helper'

# The handoff to otvorenesudy, whose Sidekiq runs UpdateRepositoryJob from the probe queue in Redis database 0 and
# reindexes the record named by [model name, id] (otvorenesudy's app/jobs/update_repository_job.rb). The job's class,
# queue, arguments and Redis database are a contract between the two apps.
RSpec.describe UpdateNotifier do
  def probe_jobs
    Sidekiq::Queues['probe']
  end

  before { Sidekiq::Queues.clear_all }

  it 'asks otvorenesudy to reindex each kind of record it indexes, by its model name and id' do
    court, judge, decree, hearing = create(:court), create(:judge), create(:decree), create(:hearing)

    [court, judge, decree, hearing].each { |record| described_class.notify(record) }

    expect(probe_jobs.map { |job| job.slice('class', 'queue', 'args') }).to eq(
      [['Court', court.id], ['Judge', judge.id], ['Decree', decree.id], ['Hearing', hearing.id]].map do |args|
        { 'class' => 'UpdateRepositoryJob', 'queue' => 'probe', 'args' => args }
      end
    )
  end

  context 'with Redis' do
    let(:redis) { RedisClient.new(url: 'redis://localhost:6379/0') }
    let(:court) { create(:court) }

    after do
      redis.call('LRANGE', 'queue:probe', 0, -1).each do |payload|
        redis.call('LREM', 'queue:probe', 0, payload) if JSON.parse(payload)['args'] == ['Court', court.id]
      end
      redis.close
    end

    it 'pushes the job into the probe queue of Redis database 0, where otvorenesudy takes it from' do
      Sidekiq::Testing.disable! { described_class.notify(court) }

      payloads = redis.call('LRANGE', 'queue:probe', 0, -1).map { |payload| JSON.parse(payload) }

      expect(payloads).to include(
        a_hash_including('class' => 'UpdateRepositoryJob', 'queue' => 'probe', 'args' => ['Court', court.id], 'retry' => true)
      )
      expect(redis.call('SISMEMBER', 'queues', 'probe')).to eq(1)
    end
  end
end
