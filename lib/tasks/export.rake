namespace :export do
  desc 'Export decrees'
  task decrees: :environment do
    ExportDecreesJob.enqueue(location: ENV['STORE'])
  end

  desc 'Export Public::ProsecutorRefinements into CSV'
  task public_prosecutor_refinements: :environment do
    CSV.open(Rails.root.join("tmp/public-prosecutor-refinements-#{Time.now.strftime('%Y%m%d%H%M')}.csv"), "w") do |csv|
      Public::ProsecutorRefinement.order(:created_at).find_each do |refinement|
        csv << [refinement.name, refinement.email, refinement.ip_address, refinement.prosecutor, refinement.office, refinement.created_at]
      end
    end
  end
end
