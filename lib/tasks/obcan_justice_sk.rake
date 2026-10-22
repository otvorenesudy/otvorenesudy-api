# frozen_string_literal: true

namespace :obcan_justice_sk do
  task consolidate_decrees: :environment do
    base_url = 'https://obcan.justice.sk/pilot/api/ress-isu-service/v1/rozhodnutie'

    response = Curl.get("#{base_url}?size=1&page=1")
    json = JSON.parse(response.body_str, symbolize_names: true)

    size = 1_000
    pages = (json[:numFound] / size.to_f).ceil

    current_guids =
      Parallel
      .map(1..pages, in_threads: 5) do |page|
        url = "#{base_url}?size=#{size}&page=#{page}"

        response = Curl.get(url)
        decrees = JSON.parse(response.body_str, symbolize_names: true)

        puts "Fetched [#{page} / #{pages}] page"

        decrees[:rozhodnutieList].map { |decree| decree[:guid] }
      end
        .flatten

    stored_guids = ObcanJusticeSk::Decree.pluck(:guid)
    orphaned_guids = stored_guids - current_guids

    puts "Found [#{orphaned_guids.size}] orphaned decrees to delete"

    orphaned_guids.each_slice(1000) { |guids_batch| ObcanJusticeSk::Decree.where(guid: guids_batch).delete_all }

    puts "Deleted [#{orphaned_guids.size}] orphaned decrees"

    stored_ids = ObcanJusticeSk::Decree.pluck(:id)
    reconciled_ids = Decree.where(source_class: 'ObcanJusticeSk::Decree').pluck(:source_class_id)
    unreconciled_ids = stored_ids - reconciled_ids
    orphaned_ids = reconciled_ids - stored_ids

    puts "Found [#{orphaned_ids.size}] orphaned and [#{unreconciled_ids.size}] unreconciled decrees " \
         'without reconciliation to delete'

    orphaned_ids.each_slice(1000) do |ids_batch|
      ObcanJusticeSk::Decree.where(id: ids_batch).delete_all
      Decree.where(source_class: 'ObcanJusticeSk::Decree',
                   source_class_id: ids_batch).delete_all
    end

    unreconciled_ids.each_slice(1000) do |ids_batch|
      ObcanJusticeSk::Decree.where(id: ids_batch).delete_all
      Decree.where(source_class: 'ObcanJusticeSk::Decree',
                   source_class_id: ids_batch).delete_all
    end

    puts "Deleted [#{orphaned_ids.size}] orphaned decrees without reconciliation"
  end
end
