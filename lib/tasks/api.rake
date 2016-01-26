namespace :api do
  namespace :export do
    desc 'Export decrees'
    task decrees: :environment do
      Api::ExportDecreesJob.enqueue(location: ENV['STORE'])
    end
  end
end
