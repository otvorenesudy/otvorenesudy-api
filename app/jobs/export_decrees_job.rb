class ExportDecreesJob < ActiveJob::Base
  queue_as :exporters

  def perform(from_id, to_id, path:)
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
    ).where(id: from_id..to_id)

    File.open(File.join(path, "#{from_id}-#{to_id}.json"), 'w') do |f|
      adapter = ActiveModel::Serializer.config.adapter
      serializer = ActiveModel::Serializer::CollectionSerializer.new(decrees, serializer: DecreeSerializer)

      f.write(adapter.new(serializer).to_json)
    end
  end

  def self.enqueue(location:)
    directory = "api-decrees-#{Time.now.strftime('%Y%m%d%H%M')}"
    path = File.join(location, directory)

    FileUtils.mkdir_p(path)

    Decree.find_in_batches do |batch|
      ExportDecreesJob.perform_later(batch.first.id, batch.last.id, path: path)
    end
  end
end
