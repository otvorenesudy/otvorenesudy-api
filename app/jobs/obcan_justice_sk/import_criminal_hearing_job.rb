module ObcanJusticeSk
  class ImportCriminalHearingJob < ::ApplicationJob
    queue_as :obcan_justice_sk

    def perform(guid)
      url = ObcanJusticeSk::CriminalHearings.hearing_url(guid)
      response = Curl.get(url)
      hearing = JSON.parse(response.body_str)

      ObcanJusticeSk::CriminalHearings.validate_json!(hearing)
      ObcanJusticeSk::CriminalHearing.import_from!(guid: guid, uri: url, data: hearing)
    end
  end
end
