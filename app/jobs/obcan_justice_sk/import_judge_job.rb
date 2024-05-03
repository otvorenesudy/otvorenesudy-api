module ObcanJusticeSk
  class ImportJudgeJob < ::ApplicationJob
    queue_as :obcan_justice_sk

    def perform(guid)
      url = ObcanJusticeSk::Judges.judge_url(guid)
      response = Curl.get(url)
      judge = JSON.parse(response.body_str, symbolize_names: true)

      ObcanJusticeSk::Judges.validate_json!(judge)
      ObcanJusticeSk::Judge.import_from!(guid: guid, uri: url, data: judge)
    end
  end
end
