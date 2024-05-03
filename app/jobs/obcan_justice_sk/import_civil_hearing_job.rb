module ObcanJusticeSk
  class ImportCivilHearingJob < ::ApplicationJob
    queue_as :obcan_justice_sk

    def perform(guid)
      url = ObcanJusticeSk::CivilHearings.hearing_url(guid)
      response = Curl.get(url)
      hearing = JSON.parse(response.body_str)

      ObcanJusticeSk::CivilHearings.validate_json!(hearing)
      ObcanJusticeSk::CivilHearing.import_from!(guid: guid, uri: url, data: hearing)
    end
  end
end
