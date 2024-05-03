module ObcanJusticeSk
  class ImportCivilHearingsJob < ::ApplicationJob
    queue_as :obcan_justice_sk

    def perform(url)
      response = Curl.get(url)
      judge = JSON.parse(response.body_str, symbolize_names: true)

      ObcanJusticeSk::CivilHearings.validate_list_json!(judge)

      judge[:obcianPojednavaniaList].each do |hearing|
        ObcanJusticeSk::ImportCivilHearingJob.perform_later(hearing[:guid])
      end
    end
  end
end
