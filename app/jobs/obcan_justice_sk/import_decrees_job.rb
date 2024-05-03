module ObcanJusticeSk
  class ImportDecreesJob < ::ApplicationJob
    queue_as :obcan_justice_sk

    def perform(url)
      response = Curl.get(url)
      judge = JSON.parse(response.body_str, symbolize_names: true)

      ObcanJusticeSk::Decrees.validate_list_json!(judge)

      judge[:rozhodnutieList].each { |decree| ObcanJusticeSk::ImportDecreeJob.perform_later(decree[:guid]) }
    end
  end
end
