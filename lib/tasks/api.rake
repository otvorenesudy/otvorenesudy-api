namespace :api do
  namespace :export do
    desc 'Export decrees'
    task :decrees, [:batch_size, :limit] => [:environment] do |_, args|
      decrees = Decree.includes(
        :pages,
        :court,
        :form,
        :legislation_area,
        :legislation_subarea,
        :natures,
        :legislations,
        :inexact_judgements,

        exact_judgements: [:judge],
        court: [:municipality],
        proceeding: [
          hearings: [:proposers, :defendants, :opponents]
        ]
      )


      directory = "api-decrees-#{Time.now.strftime('%Y%m%d%H%M')}"
      index = 0
      adapter = ActiveModel::Serializer.config.adapter

      path = ENV['PATH'] || Rails.root.join('tmp')

      FileUtils.mkdir_p("#{path}/#{directory}")

      batch_size = args[:batch_size] ? args[:batch_size].to_i : 10_000
      end_at = args[:limit] ? decrees.order(:id).limit(args[:limit].to_i).last.id : nil

      decrees.find_in_batches(batch_size: batch_size, end_at: end_at)  do |batch|
        File.open(Rails.root.join('tmp', directory, "%03d.json" % index), 'w') do |f|
          serializer = ActiveModel::Serializer::ArraySerializer.new(batch, serializer: DecreeSerializer)

          f.write(adapter.new(serializer).to_json)
        end

        index += 1
      end
    end
  end
end
