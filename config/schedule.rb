# Use this file to easily define all of your cron jobs.
#
# It's helpful, but not entirely necessary to understand cron before proceeding.
# http://en.wikipedia.org/wiki/Cron

# Example:
#
# set :output, "/path/to/my/cron_log.log"
#
# every 2.hours do
#   command "/usr/bin/some_great_command"
#   runner "MyModel.some_method"
#   rake "some:great:rake:task"
# end
#
# every 4.days do
#   runner "AnotherModel.prune_old_records"
# end

# Learn more: http://github.com/javan/whenever

set :output, 'log/cron.log'

every :day, at: '10 pm' do
  command 'OPENCOURTS_DATABASE_NAME=opencourts_production python3 ml/decree-embeddings/embed.py'
end

every :day, at: '3:00 am' do
  runner 'ExceptionHandler.run { ObcanJusticeSk::Courts.import }'
end

every :day, at: '3:05 am' do
  runner ' ExceptionHandler.run { ObcanJusticeSk::Judges.import }'
end

every :day, at: '3:10 am' do
  runner 'ExceptionHandler.run { ObcanJusticeSk::CivilHearings.import }'
end

every :day, at: '3:20 am' do
  runner 'ExceptionHandler.run { ObcanJusticeSk::CriminalHearings.import }'
end

%i[monday tuesday wednesday thursday friday].each do |day|
  every day, at: '4:00 am' do
    runner 'ExceptionHandler.run { ObcanJusticeSk::Decrees.import(since: 6.months.ago) }'
  end
end

every :saturday, at: '4:00 am' do
  runner 'ExceptionHandler.run { ObcanJusticeSk::Decrees.import }'
end
