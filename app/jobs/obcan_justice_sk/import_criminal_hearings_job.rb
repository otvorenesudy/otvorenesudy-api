module ObcanJusticeSk
  class ImportCriminalHearingsJob < ::ApplicationJob
    queue_as :obcan_justice_sk

    def perform(url)
      response = Curl.get(url)
      judge = JSON.parse(response.body_str, symbolize_names: true)

      ObcanJusticeSk::CriminalHearings.validate_list_json!(judge)

      judge[:data].each { |hearing| ObcanJusticeSk::ImportCriminalHearingJob.perform_later(hearing[:id]) }
    end
  end
end
