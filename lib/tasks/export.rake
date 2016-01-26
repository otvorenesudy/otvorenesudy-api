namespace :export do
  desc 'Export decrees'
  task decrees: :environment do
    ExportDecreesJob.enqueue(location: ENV['STORE'])
  end
end
